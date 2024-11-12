@RestResource(urlMapping='/stripe-checkout')
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

			// Step 3: Map interval if applicable
			if (recurrence != null && recurrence.interval != null) {
				recurrence.interval = mapInterval(recurrence.interval);
			}

			// Step 4: Retrieve or create the Contact and Account
			AccountContactService accService = new AccountContactService();
			Contact contact = accService.getOrCreateContact(stripeResponse.data.objectz.customer_details);

			// Step 5: Add to campaign if campaign ID is provided and valid
			if (!String.isBlank(metadata.campaignId) && metadata.campaignId != 'undefined') {
				CampaignService campaignService = new CampaignService();
				campaignService.createCampaignMember(contact.Id, metadata.campaignId);
			} else {
				System.debug('No valid Campaign ID provided for transaction ID: ' + transactionId);
			}

			// Step 6: Create donation record
			DonationRecordService donationService = new DonationRecordService();
			if (isRecurring) {
				donationService.createRecurringGift(contact, stripeResponse, recurrence, honoree);
			} else {
				donationService.createOneTimeGift(contact, stripeResponse, honoree);
			}

			// Step 7: Respond with success
			responseMap.put('success', true);
			responseMap.put('message', 'Donation processed successfully.');
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
		} catch (Exception e) {
			// Catch unexpected errors
			responseMap.put('success', false);
			responseMap.put('error', 'Error in processing StripeCallbackResource: ' + e.getMessage());
			System.debug(
				'Unexpected error in StripeCallbackResource (transaction ID: ' + transactionId + '): ' + e.getMessage()
			);
		}

		// Step 8: Send JSON response
		RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseMap));
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
