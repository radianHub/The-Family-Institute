/**
 * @Class Name     : StripeCancellationCallbackResource
 * @Class Purpose  : Listens for a stripe subscription cancellation.
 * @Author         : Zachary Csotya
 * @Developed On   : 01/10/2025
 * @Last Modified  : 01/10/2025
 **/
@RestResource(UrlMapping='/cancellation')
global without sharing class StripeCancellationCallbackResource {
	/**
	 * @description Processes the incoming stripe cancellation payload and ends the associated gift commitment and gift commitment schedule.
	 * @author Zachary Csotya | 01/10/2025
	 **/
	@HttpPost
	global static void doPost() {
		StripeCancellationResponse stripeResponse;
		try {
			try {
				String requestBody = RestContext.request.requestBody.toString().replaceAll('object', 'objectz');
				requestBody = requestBody.replaceAll('currency', 'currencyz');
				requestBody = requestBody.replace('"end"', '"endz"');
				stripeResponse = (StripeCancellationResponse) System.JSON.deserialize(
					requestBody,
					StripeCancellationResponse.class
				);
			} catch (Exception ex) {
				throw new DonationProcessingException(
					'An error occurred while processing Stripe Cancellation request: ' + ex.getMessage(),
					ex
				);
			}

			DonationRecordService donorService = new DonationRecordService();
			donorService.endGiftCommitment(StripeResponse);

			RestContext.response.statusCode = 204;
		} catch (DonationProcessingException ex) {
			RestContext.response.responseBody = Blob.valueOf(
				JSON.serialize(new Map<String, String>{ 'message' => ex.getMessage() })
			);
			RestContext.response.statusCode = 400;
		} catch (Exception ex) {
			RestContext.response.responseBody = Blob.valueOf(
				System.JSON.serialize(
					new Map<String, String>{
						'message' => 'An error occurred while trying to cancel the gift commitment for subscription id: ' +
						stripeResponse.data.objectz.id
					}
				)
			);
			RestContext.response.statusCode = 500;
		}
	}
}
