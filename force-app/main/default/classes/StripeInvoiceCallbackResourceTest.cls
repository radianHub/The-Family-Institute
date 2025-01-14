@isTest
private class StripeInvoiceCallbackResourceTest {
	// # DATA SETUP
	private static RestRequest req;
	private static RestResponse res;
	private static Account person;
	private static Account org;
	private static Campaign camp;
	private static OutreachSourceCode osc;
	private static StripeResponse stripePayload;
	private static StripeInvoiceResponse stripeInvoicePayload;
	private static DonationRecordService donorService = new DonationRecordService();

	private static void buildRestContext(Blob requestBody) {
		req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestURI = '/services/apexrest/invoice';
		req.requestBody = requestBody;
		RestContext.request = req;

		res = new RestResponse();
		RestContext.response = res;
	}

	private static void makeRecordData() {
		camp = (Campaign) new SObjectBuilder(Campaign.SObjectType).create().getRecord();
		osc = (OutreachSourceCode) new SObjectBuilder(OutreachSourceCode.SObjectType)
			.put(OutreachSourceCode.CampaignId, camp.Id)
			.create()
			.getRecord();
		new SObjectBuilder(GiftDefaultDesignation.SObjectType)
			.put(GiftDefaultDesignation.ParentRecordId, camp.Id)
			.create();
		person = (Account) new SObjectBuilder(Account.SObjectType)
			.put(
				Account.RecordTypeId,
				Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId()
			)
			.put(Account.FirstName, 'Test')
			.put(Account.LastName, 'Person')
			.create()
			.getRecord();
		org = (Account) new SObjectBuilder(Account.SObjectType)
			.put(
				Account.RecordTypeId,
				Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Organization').getRecordTypeId()
			)
			.put(Account.Name, 'Test Org')
			.create()
			.getRecord();
	}
	private static void makeCheckoutData(Blob payload) {
		String stripeResponse = payload.toString().replace('object', 'objectz');
		stripePayload = (StripeResponse) System.JSON.deserialize(stripeResponse, StripeResponse.class);
	}
	private static void makeInvoiceData(Blob payload) {
		String stripeResponse = payload.toString().replace('object', 'objectz');
		stripeResponse = stripeResponse.replaceFirst('number', 'inv_number');
		stripeInvoicePayload = (StripeInvoiceResponse) System.JSON.deserialize(
			stripeResponse,
			StripeInvoiceResponse.class
		);
	}

	// # UNIT TESTS
	@isTest
	private static void handleIncomingInvoiceTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory(camp.Id, osc.Id).recurringDonationPerson());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);
		StripeResponse.cls_recurrence recur = new StripeResponse.cls_recurrence()
			.parse(stripePayload.data.objectz.metadata.recurrence);
		makeInvoiceData(new StripeTestDataFactory().invoicePerson());
		donorService.createRecurringGift(null, person.Id, stripePayload, recur, honoree, match, 'Individual');

		GiftCommitment commitment = [
			SELECT Id, CurrentGiftCmtScheduleId
			FROM GiftCommitment
			WHERE StripeSubscriptionId__c = :stripeInvoicePayload.data.objectz.subscription
		];

		new SObjectBuilder(GiftTransaction.SObjectType)
			.put(GiftTransaction.Name, 'Test')
			.put(GiftTransaction.DonorId, person.Id)
			.put(GiftTransaction.TransactionDAte, Date.today().addDays(7))
			.put(GiftTransaction.TransactionDueDate, Date.today().addDAys(7))
			.put(GiftTransaction.Status, 'Paid')
			.put(GiftTransaction.OriginalAmount, 15)
			.put(GiftTransaction.PaymentMethod, 'Stripe')
			.put(GiftTransaction.GiftCommitmentId, commitment.Id)
			.put(GiftTransaction.GiftCommitmentScheduleId, commitment.CurrentGiftCmtScheduleId)
			.create();

		buildRestContext(new StripeTestDataFactory().invoicePerson());

		// * Actual test
		StripeInvoiceCallbackResource.doPost();

		// * Asserts
		List<GiftTransaction> gifts = [SELECT Id FROM GiftTransaction WHERE stripeId__c != NULL];
		Assert.areEqual(2, gifts.size(), 'Expected to have 2 records with stripe ids.');
	}

	@isTest
	private static void handleIncomingInvoiceNoTransactionTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory().recurringDonationPerson());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);
		StripeResponse.cls_recurrence recur = new StripeResponse.cls_recurrence()
			.parse(stripePayload.data.objectz.metadata.recurrence);
		donorService.createRecurringGift(null, person.Id, stripePayload, recur, honoree, match, 'Individual');
		buildRestContext(new StripeTestDataFactory().invoicePerson());

		// * Actual test
		StripeInvoiceCallbackResource.doPost();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(false, resBody.get('success'), 'Donation processed successfully, Expected failure.');
	}

	@isTest
	private static void handleIncomingInvoiceBadTest() {
		// * Test data setup
		buildRestContext(null);

		// * Actual test
		StripeInvoiceCallbackResource.doPost();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(false, resBody.get('success'), 'Donation processed successfully, Expected failure.');
	}
}
