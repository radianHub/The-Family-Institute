/**
 * @Class Name     : StripeCallbackResource
 * @Class Purpose  : Listens for a successful Stripe Checkout Session completion and processes the donation.
 * @Author         : Zachary Csotya
 * @Developed On   : 12/31/2024
 * @Last Modified  : 03/21/2025
 **/
// TODO: write additional test coverage
@RestResource(urlMapping='/checkout')
global without sharing class StripeCallbackResource {
	/**
	 * @description Processes the incoming stripe checkout session payload and creates/updates the necessary records.
	 * @author Zachary Csotya | 12/30/2024
	 **/
	@HttpPost
	global static void doPost() {
		Map<String, Object> responseMap = new Map<String, Object>();
		String transactionId;
		try {
			// * Parse JSON, replacing reserved word 'object'
			System.debug(System.JSON.serializePretty(System.RestContext.request.requestBody.toString()));
			String requestBody = RestContext.request.requestBody.toString().replace('object', 'objectz');
			StripeResponse stripeResponse = (StripeResponse) System.JSON.deserialize(requestBody, StripeResponse.class);

			// * Retrieve transaction ID for logging
			transactionId = stripeResponse.id;
			System.debug('Processing transaction ID: ' + transactionId);

			// * Instantiate service classes
			AccountService accService = new AccountService();
			CampaignService campaignService = new CampaignService();
			DonationRecordService donationService = new DonationRecordService();

			// * Extract and process metadata (gift type, honoree, recurrence)
			StripeResponse.cls_metadata metadata = stripeResponse.data.objectz.metadata;
			Boolean isRecurring = stripeResponse.data.objectz.mode == 'subscription';
			Boolean isTicketing = metadata.type == 'ticketing';
			StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree().parse(metadata.honoree);
			StripeResponse.cls_recurrence recurrence = new StripeResponse.cls_recurrence().parse(metadata.recurrence);
			StripeResponse.cls_organization org = new StripeResponse.cls_organization().parse(metadata.organization);
			StripeResponse.cls_employer match = new StripeResponse.cls_employer().parse(metadata.match);

			if (isTicketing) {
				StripeResponse.cls_payer payer = new StripeResponse.cls_payer().parse(metadata.payer);

				// * Retrieve or create Person Account
				Id personId = accService.getOrCreatePersonAccount(payer);

				// * Create campaign member for Person
				if (!String.isBlank(metadata.campaignId) && metadata.campaignId != 'undefined') {
					campaignService.createCampaignMember(personId, metadata.campaignId);
				} else {
					System.debug('No campaign ID provided for transaction ID: ' + transactionId);
				}

				// * Create purchase record
				if (stripeResponse.data.objectz.invoice == null) {
					// * Create gift transactions (of type ticket) for each ticket purchased
					DonationRecordService.createOneTimeGift(
						personId,
						metadata.campaignId,
						stripeResponse.data.objectz.id,
						'Ticket'
					);
				} else {
					// * Create recurring gift transactions (of type ticket) for each tieck purchased
					donationService.createRecurringGift(
						personId,
						metadata.campaignId,
						stripeResponse,
						metadata.paymentLength,
						'Ticket'
					);
				}
			} else {
				// * Retrieve or create the Account
				Id accId;
				Id personId;
				if (org.isOrg) {
					Map<String, Id> orgPersonIds = accService.getOrCreateOrgAccount(
						StripeResponse.data.objectz.customer_details,
						org
					);
					accId = orgPersonIds.get('org');
					personId = orgPersonIds.get('person');
				} else {
					personId = accService.getOrCreatePersonAccount(stripeResponse.data.objectz.customer_details);
				}

				// * Add to campaign if campaign ID is provided and valid
				if (!String.isBlank(metadata.campaignId) && metadata.campaignId != 'undefined') {
					campaignService.createCampaignMember(personId, metadata.campaignId);
				} else {
					System.debug('No valid Campaign ID provided for transaction ID: ' + transactionId);
				}

				// * Create donation record
				if (isRecurring) {
					donationService.createRecurringGift(
						accId,
						personId,
						stripeResponse,
						recurrence,
						honoree,
						match,
						org != null && org.isOrg ? 'Organizational' : 'Individual'
					);
				} else {
					donationService.createOneTimeGift(
						accId,
						personId,
						stripeResponse,
						honoree,
						match,
						org != null && org.isOrg ? 'Organizational' : 'Individual'
					);
				}
			}

			// * Respond with success
			responseMap.put('success', true);
			responseMap.put('message', 'Donation processed successfully.');
			RestContext.response.responseBody = Blob.valueOf(System.JSON.serialize(responseMap));
		} catch (DonationProcessingException dpe) {
			// * Handle known donation processing errors
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
			// * Catch unexpected errors
			responseMap.put('success', false);
			responseMap.put('error', 'Error in processing StripeCallbackResource: ' + e.getMessage());
			System.debug(
				'Unexpected error in StripeCallbackResource (transaction ID: ' + transactionId + '): ' + e.getMessage()
			);
			RestContext.response.statusCode = 400;
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseMap));
		}
	}
}
