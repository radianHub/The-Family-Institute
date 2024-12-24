@RestResource(UrlMapping='/invoice')
global without sharing class StripeInvoiceCallbackResource {
	@HttpPost
	global static void doPost() {
		String d = RestContext.request.requestBody.toString();

		// * REFORMAT JSON
		String formattedJSONString = d.replace('object', 'objectz');
		formattedJSONString = formattedJSONString.replaceFirst('number', 'inv_number');

		// * PARSE JSON RESPONSE
		StripeInvoiceResponse res = (StripeInvoiceResponse) JSON.deserialize(
			formattedJSONString,
			StripeInvoiceResponse.class
		);

		System.debug(formattedJSONString);

		System.debug(res.data.objectz.subscription);
		System.debug(res.data.objectz.id);

		// * FETCH PLEDGED OPPORTUNITY TO ASSIGN INVOICE ID
		// List<Opportunity> oppList = [
		//     SELECT Id, Stripe_Transaction_Id__c, RecordTypeId
		//     FROM Opportunity
		//     WHERE npe03__Recurring_Donation__r.Stripe_Subscription_Id__c = :res.data.objectz.subscription AND Stripe_Transaction_Id__c = :res.data.objectz.id
		// ];

		System.debug('Donation:::');
		// System.debug([SELECT Id FROM npe03__Recurring_Donation__c WHERE Stripe_Subscription_Id__c = :res.data.objectz.subscription]);

		// if (oppList.size() == 0) {
		//     Opportunity opp = [
		//         SELECT Id, Stripe_Transaction_Id__c, RecordTypeId
		//         FROM Opportunity
		//         WHERE npe03__Recurring_Donation__r.Stripe_Subscription_Id__c = :res.data.objectz.subscription AND Stripe_Transaction_Id__c = null
		//     ];
		//     update opp;

		//     // * MARK PAYMENT PAID
		//     npe01__OppPayment__c pmnt = [
		//         SELECT
		//             Id,
		//             npe01__Payment_Method__c,
		//             npe01__Paid__c,
		//             npe01__Payment_Date__c
		//         FROM
		//             npe01__OppPayment__c
		//         WHERE
		//             npe01__Opportunity__c = :opp.Id AND npe01__Paid__c = false
		//     ];
		//     pmnt.npe01__Paid__c = res.data.objectz.status == 'paid' ? true : false;
		//     pmnt.npe01__Payment_Date__c = DateTime.newInstance(((Long) res.data.objectz.created) * 1000).date();
		//     update pmnt;
		// }
	}
}
