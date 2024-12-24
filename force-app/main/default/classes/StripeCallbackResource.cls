@RestResource(urlMapping='/checkout')
global without sharing class StripeCallbackResource {
	@HttpPost
	global static void doPost() {
		Map<String, Object> responseMap = new Map<String, Object>();
		String transactionId;
		try {
			// Step 1: Parse JSON, replacing reserved word 'object'
			String requestBody = RestContext.request.requestBody.toString().replace('object', 'objectz');
			StripeResponse stripeResponse = (StripeResponse) JSON.deserialize(requestBody, StripeResponse.class);

			// Retrieve transaction ID for logging
			transactionId = stripeResponse.id;
			System.debug('Processing transaction ID: ' + transactionId);

			// Step 2: Extract and process metadata (gift type, honoree, recurrence)
			StripeResponse.cls_metadata metadata = stripeResponse.data.objectz.metadata;
			Boolean isRecurring = stripeResponse.data.objectz.mode == 'subscription';
			StripeResponse.cls_honoree honoree = metadata.honoree != null
				? new StripeResponse.cls_honoree().parse(metadata.honoree)
				: null;
			StripeResponse.cls_recurrence recurrence = metadata.recurrence != null
				? new StripeResponse.cls_recurrence().parse(metadata.recurrence)
				: null;
			StripeResponse.cls_organization org = metadata.organization != null
				? new StripeResponse.cls_organization().parse(metadata.organization)
				: null;
			StripeResponse.cls_employer match = metadata.match != null
				? new StripeResponse.cls_employer().parse(metadata.match)
				: null;

			System.debug(metadata);

			// Step 3: Map interval if applicable
			if (recurrence != null && recurrence.interval != null) {
				recurrence.interval = mapInterval(recurrence.interval);
			}

			// Step 4: Retrieve or create the Account
			AccountService accService = new AccountService();
			Id accId;
			Id personId;
			if (org != null && org.isOrg) {
				Map<String, Id> orgPersonIds = accService.getOrCreateOrgAccount(
					StripeResponse.data.objectz.customer_details,
					org
				);
				accId = orgPersonIds.get('org');
				personId = orgPersonIds.get('person');
			} else {
				personId = accService.getOrCreatePersonAccount(stripeResponse.data.objectz.customer_details);
			}

			// Step 5: Add to campaign if campaign ID is provided and valid
			if (!String.isBlank(metadata.campaignId) && metadata.campaignId != 'undefined') {
				CampaignService campaignService = new CampaignService();
				campaignService.createCampaignMember(personId, metadata.campaignId);
			} else {
				System.debug('No valid Campaign ID provided for transaction ID: ' + transactionId);
			}

			// Step 6: Create donation record
			DonationRecordService donationService = new DonationRecordService();
			donationService.createOneTimeGift(
				accId,
				personId,
				stripeResponse,
				honoree,
				match,
				org != null && org.isOrg ? 'Organizational' : 'Individual'
			);

			// Step 7: Respond with success
			responseMap.put('success', true);
			responseMap.put('message', 'Donation processed successfully.');
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseMap));
		} catch (DonationProcessingException dpe) {
			// Handle known donation processing errors
			responseMap.put('success', false);
			responseMap.put('error', 'Donation processing error: ' + dpe.getMessage());
			System.debug(
				'DonationProcessingException in StripeCallbackResource (transaction ID: ' +
					transactionId +
					'): ' +
					dpe.getMessage()
			);
			RestContext.response.statusCode = 500;
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseMap));
		} catch (Exception e) {
			// Catch unexpected errors
			responseMap.put('success', false);
			responseMap.put('error', 'Error in processing StripeCallbackResource: ' + e.getMessage());
			System.debug(
				'Unexpected error in StripeCallbackResource (transaction ID: ' + transactionId + '): ' + e.getMessage()
			);
			RestContext.response.statusCode = 400;
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseMap));
		}
	}

	/**
	 * Maps recurring intervals from Stripe to Salesforce-compatible values.
	 * @param interval The interval from Stripe, e.g., 'week', 'month'.
	 * @return A Salesforce field-compatible interval value.
	 */
	private static String mapInterval(String interval) {
		switch on interval.toLowerCase() {
			when 'week' {
				return 'Week';
			}
			when 'bi-week' {
				return 'Bi-Week';
			}
			when 'month' {
				return 'Month';
			}
			when 'quarter' {
				return 'Quarter';
			}
			when 'year' {
				return 'Yearly';
			}
			when else {
				return 'Once';
			}
		}
	}
}
