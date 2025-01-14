/**
 * @Class Name     : StripeInvoiceCallbackResource
 * @Class Purpose  : Listens for a successful Stripe Invoice completion and processes the donation.
 * @Author         : Zachary Csotya
 * @Developed On   : 12/30/2024
 * @Last Modified  : 12/30/2024
 **/
@RestResource(UrlMapping='/invoice')
global without sharing class StripeInvoiceCallbackResource {
	/**
	 * @description Processes the incoming stripe invoice payload and creates/updates the necessary records.
	 * @author Zachary Csotya | 12/30/2024
	 **/
	@HttpPost
	global static void doPost() {
		Map<String, Object> responseMap = new Map<String, Object>();
		String transactionId;
		try {
			// * Parse JSON, replacing reserved word 'object' and 'number'
			String requestBody = RestContext.request.requestBody.toString().replace('object', 'objectz');
			requestBody = requestBody.replaceFirst('number', 'inv_number');
			StripeInvoiceResponse stripeResponse = (StripeInvoiceResponse) JSON.deserialize(
				requestBody,
				StripeInvoiceResponse.class
			);

			// * Retrieve transaction ID for logging
			transactionId = stripeResponse.id;
			System.debug('Processing transaction ID: ' + transactionId);

			// * Extract and process metadata (gift type, honoree, recurrence)
			StripeInvoiceResponse.cls_metadata metadata = stripeResponse.data.objectz.metadata;

			// * Update gift transactions with incoming invoice data
			DonationRecordService donation = new DonationRecordService();
			donation.handleIncomingInvoice(stripeResponse);

			// * Respond with success
			responseMap.put('success', true);
			responseMap.put('message', 'Donation processed successfully.');
			RestContext.response.responseBody = Blob.valueOf(System.JSON.serialize(responseMap));
		} catch (DonationProcessingException ex) {
			// * Handle known donation errors
			responseMap.put('success', false);
			responseMap.put('error', 'Donation processing error: ' + ex.getMessage());
			System.debug(
				'DonationProcessingException in StripeInvoiceCallbackResource (transaction ID: ' +
					transactionId +
					'): ' +
					ex.getMessage()
			);
			RestContext.response.statusCode = 500;
			RestContext.response.responseBody = Blob.valueOf(System.JSON.serialize(responseMap));
		} catch (Exception e) {
			// * Handle unknown errors
			responseMap.put('success', false);
			responseMap.put('error', 'Error in processing StripeInvoiceCallbackResource: ' + e.getMessage());
			System.debug(
				'Unexpected error in StripeInvoiceCallbackResource (transaction ID: ' +
					transactionId +
					'): ' +
					e.getMessage()
			);
			RestContext.response.statusCode = 400;
			RestContext.response.responseBody = Blob.valueOf(System.JSON.serialize(responseMap));
		}
	}
}
