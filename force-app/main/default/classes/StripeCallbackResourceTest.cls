@isTest
private class StripeCallbackResourceTest {
	// # DATA SETUP
	private static Campaign camp;
	private static OutreachSourceCode osc;
	private static GiftDefaultDesignation gdd;
	private static RestRequest req;
	private static RestResponse res;
	private static Map<String, HttpResponse> resStore = new Map<String, HttpResponse>{
		'lineItemSuccess' => HttpResponseFactory.lineItemSuccess(),
		'lineItemFailure' => HttpResponseFactory.lineItemFailure()
	};
	private static List<HttpMatchingStrategy> matchers = new List<HttpMatchingStrategy>{
		new HttpResponseMatchers.SessionLineItemMatcher()
	};

	private static void makeData() {
		camp = (Campaign) new SObjectBuilder(Campaign.SObjectType).create().getRecord();
		osc = (OutreachSourceCode) new SObjectBuilder(OutreachSourceCode.SObjectType)
			.put(OutreachSourceCode.CampaignId, camp.Id)
			.create()
			.getRecord();
		gdd = (GiftDefaultDesignation) new SObjectBuilder(GiftDefaultDesignation.SObjectType)
			.put(GiftDefaultDesignation.ParentRecordId, camp.Id)
			.create()
			.getRecord();
	}
	private static void buildRestContext(Blob requestBody) {
		req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestURI = '/services/apexrest/checkout';
		req.requestBody = requestBody;
		RestContext.request = req;

		res = new RestResponse();
		RestContext.response = res;
	}

	// # UNIT TESTS
	@isTest
	private static void oneTimeDonationOrgSuccessTest() {
		// * Test data setup
		makeData();
		StripeTestDataFactory stf = new StripeTestDataFactory(camp.Id, osc.Id);
		buildRestContext(stf.oneTimeDonationOrg());

		// * Actual test
		StripeCallbackResource.doPost();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(true, resBody.get('success'), 'Donation failed. Expected success.');

		List<GiftTransaction> gift = [SELECT Id, DonorId, Donor.RecordTypeId FROM GiftTransaction];
		Assert.areEqual(1, gift.size(), 'No gift transaction created.');
		Assert.isNotNull(gift[0].DonorId, 'No donor ID assigned to gift transaction.');
		Assert.areEqual(
			Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Organization').getRecordTypeId(),
			gift[0].Donor.RecordTypeId,
			'Donor is not an organization.'
		);

		List<GiftTransactionDesignation> giftDesignation = [
			SELECT Id
			FROM GiftTransactionDesignation
			WHERE GiftTransactionId = :gift[0].Id
		];
		Assert.areEqual(1, giftDesignation.size(), 'No gift transaction designation created.');

		List<GiftTribute> giftTrib = [SELECT Id FROM GiftTribute WHERE GiftTransactionId = :gift[0].Id];
		Assert.areEqual(1, giftTrib.size(), 'No gift tribute created.');
	}

	@isTest
	private static void oneTimeDonationPersonSuccessTest() {
		// * Test data setup
		StripeTestDataFactory stf = new StripeTestDataFactory();
		buildRestContext(stf.oneTimeDonationPerson());

		// * Actual test
		StripeCallbackResource.doPost();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(true, resBody.get('success'), 'Donation failed. Expected success.');

		List<GiftTransaction> gift = [SELECT Id, DonorId, Donor.RecordTypeId FROM GiftTransaction];
		Assert.areEqual(1, gift.size(), 'No gift transaction created.');
		Assert.isNotNull(gift[0].DonorId, 'No donor ID assigned to gift transaction.');
		Assert.areEqual(
			Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(),
			gift[0].Donor.RecordTypeId,
			'Donor is not a person account.'
		);
	}

	@isTest
	private static void ontTimeDonationPersonFailTest() {
		// * Test data setup
		StripeTestDataFactory stf = new StripeTestDataFactory();
		buildRestContext(stf.oneTimeDonationNoCustomerDetails());

		// * Actual test
		StripeCallbackResource.doPost();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(false, resBody.get('success'), 'Donation processed successfully. Expected failure.');
	}

	@isTest
	private static void ontTimeDonationBadRequestTest() {
		// * Test data setup
		StripeTestDataFactory stf = new StripeTestDataFactory();
		buildRestContext(stf.oneTimeDonationBadRequest());

		// * Actual test
		StripeCallbackResource.doPost();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(false, resBody.get('success'), 'Donation processed successfully. Expected failure.');
	}

	@isTest
	private static void recurringDonationPersonSuccessTest() {
		// * Test data setup
		makeData();
		StripeTestDataFactory stf = new StripeTestDataFactory(camp.Id, osc.Id);
		buildRestContext(stf.recurringDonationPerson());

		// * Actual test
		StripeCallbackResource.doPost();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(true, resBody.get('success'), 'Donation failed. Expected success.');

		List<GiftTransaction> gift = [SELECT Id, DonorId, Donor.RecordTypeId, GiftCommitmentId FROM GiftTransaction];
		Assert.areEqual(1, gift.size(), 'No gift transaction created.');
		Assert.isNotNull(gift[0].DonorId, 'No donor ID assigned to gift transaction.');
		Assert.areEqual(
			Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(),
			gift[0].Donor.RecordTypeId,
			'Donor is not a person account.'
		);

		List<GiftCommitment> commitment = [
			SELECT Id, CurrentGiftCmtScheduleId
			FROM GiftCommitment
			WHERE Id = :gift[0].GiftCommitmentId
		];
		Assert.areEqual(1, commitment.size(), 'No gift commitment created.');
		Assert.isNotNull(commitment[0].CurrentGiftCmtScheduleId, 'No gift commitment schedule created.');
	}

	@isTest
	private static void oneTimeTicketPurchaseTest() {
		// * Test data setup
		MockMultiHttpResponseGenerator mock = new MockMultiHttpResponseGenerator(resStore, matchers, true);
		Test.setMock(HttpCalloutMock.class, mock);
		makeData();
		StripeTestDataFactory stf = new StripeTestDataFactory(camp.Id, null);
		buildRestContext(stf.oneTimeTicketPurchase());

		// * Actual test
		Test.startTest();
		StripeCallbackResource.doPost();
		Test.stopTest();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(true, resBody.get('success'), 'Ticket purchase failed. Expected success.');

		List<GiftTransaction> tickets = [SELECT Id, DonorId FROM GiftTransaction];
		Assert.areEqual(1, tickets.size(), 'No ticket transaction created.');
		Assert.isNotNull(tickets[0].DonorId, 'No donor id assigned to gift transaction.');
	}

	@isTest
	private static void recurringTicketPurchaseTest() {
		// * Test data setup
		makeData();
		StripeTestDataFactory stf = new StripeTestDataFactory(camp.Id, null);
		buildRestContext(stf.recurringTicketPurchase());

		// * Actual test
		StripeCallbackResource.doPost();

		// * Asserts
		Map<String, Object> resBody = (Map<String, Object>) System.JSON.deserializeUntyped(res.responseBody.toString());
		Assert.areEqual(true, resBody.get('success'), 'Ticket purchase failed. Expected success.');

		List<GiftTransaction> tickets = [SELECT Id, DonorId, GiftCommitmentId FROM GiftTransaction];
		Assert.areEqual(1, tickets.size(), 'No ticket transaction created.');
		Assert.isNotNull(tickets[0].DonorId, 'No donor id assigned to gift transaction.');

		List<GiftCommitment> commitment = [
			SELECT Id, CurrentGiftCmtScheduleId
			FROM GiftCommitment
			WHERE Id = :tickets[0].GiftCommitmentId
		];
		Assert.areEqual(1, commitment.size(), 'No gift commitment created.');
		Assert.isNotNull(commitment[0].CurrentGiftCmtScheduleId, 'No gift commitment schedule created.');
	}
}
