@isTest
private class DonationRecordServiceTest {
	// # DATA SETUP
	private static Campaign camp;
	private static OutreachSourceCode osc;
	private static Account person;
	private static Account org;
	private static StripeResponse stripePayload;
	private static StripeInvoiceResponse stripeInvoicePayload;
	private static StripeCancellationResponse stripeCancellationPayload;
	private static DonationRecordService donorService = new DonationRecordService();
	private static String exMsg;
	private static Map<String, HttpResponse> resStore = new Map<String, HttpResponse>{
		'lineItemSuccess' => HttpResponseFactory.lineItemSuccess(),
		'lineItemFailure' => HttpResponseFactory.lineItemFailure()
	};
	private static List<HttpMatchingStrategy> matchers = new List<HttpMatchingStrategy>{
		new HttpResponseMatchers.SessionLineItemMatcher()
	};

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
	private static void makeCancellationData(String subId, Blob payload) {
		Account acc = (Account) new SObjectBuilder(Account.SObjectType)
			.put(Account.LastName, 'Smith')
			.create()
			.getRecord();
		GiftCommitment gift = (GiftCommitment) new SObjectBuilder(GiftCommitment.SObjectType)
			.put(GiftCommitment.StripeSubscriptionId__c, subId)
			.put(GiftCommitment.DonorId, acc.Id)
			.create()
			.getRecord();

		GiftCommitmentSchedule giftSchedule = (GiftCommitmentSchedule) new SObjectBuilder(
				GiftCommitmentSchedule.SObjectType
			)
			.put(GiftCommitmentSchedule.GiftCommitmentId, gift.Id)
			.create()
			.getRecord();

		gift.CurrentGiftCmtScheduleId = giftSchedule.Id;
		update gift;

		String stripeResponse = payload.toString().replaceAll('object', 'objectz');
		stripeResponse = stripeResponse.replaceAll('currency', 'currencyz');
		stripeResponse = stripeResponse.replace('"end"', '"endz"');
		stripeCancellationPayload = (StripeCancellationResponse) System.JSON.deserialize(
			stripeResponse,
			StripeCancellationResponse.class
		);
	}

	// # UNIT TESTS
	@isTest
	private static void createOneTimeGiftTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory().oneTimeDonationPerson());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);

		// * Actual test
		donorService.createOneTimeGift(null, person.Id, stripePayload, honoree, match, 'Individual');

		// * Asserts
		List<GiftTransaction> gifts = [SELECT Id FROM GiftTransaction];
		Assert.areEqual(1, gifts.size(), 'No gift transaction created.');
	}

	@isTest
	private static void oneTimeGiftWithCampaignTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory(camp.Id, null).oneTimeDonationPerson());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);

		// * Actual test
		donorService.createOneTimeGift(null, person.Id, stripePayload, honoree, match, 'Individual');

		// * Asserts
		List<GiftTransaction> gifts = [SELECT Id, CampaignId FROM GiftTransaction];
		Assert.areEqual(1, gifts.size(), 'No gift transaction created.');
		Assert.isNotNull(gifts[0].CampaignId, 'No campaign id assigned to gift transaction.');

		List<GiftTransactionDesignation> giftDesignations = [SELECT Id FROM GiftTransactionDesignation];
		Assert.areEqual(1, giftDesignations.size(), 'No gift designation created.');
	}

	@isTest
	private static void oneTimeGiftWithOSCTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory(null, osc.Id).oneTimeDonationPerson());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);

		// * Actual test
		donorService.createOneTimeGift(null, person.Id, stripePayload, honoree, match, 'Individual');

		// * Asserts
		List<GiftTransaction> gifts = [SELECT Id, OutreachSourceCodeId FROM GiftTransaction];
		Assert.areEqual(1, gifts.size(), 'No gift transaction created.');
		Assert.isNotNull(gifts[0].OutreachSourceCodeId, 'No outreach source code id assigned to gift transaction.');

		List<GiftTransactionDesignation> giftDesignations = [SELECT Id FROM GiftTransactionDesignation];
		Assert.areEqual(1, giftDesignations.size(), 'No gift designation created.');
	}

	@isTest
	private static void oneTimeGiftWithHonoreeTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory(null, osc.Id).oneTimeDonationOrg());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);

		// * Actual test
		donorService.createOneTimeGift(org.Id, null, stripePayload, honoree, match, 'Organizational');

		// * Asserts
		List<GiftTransaction> gifts = [SELECT Id, OutreachSourceCodeId FROM GiftTransaction];
		Assert.areEqual(1, gifts.size(), 'No gift transaction created.');

		List<GiftTribute> giftTributes = [SELECT Id FROM GiftTribute];
		Assert.areEqual(1, giftTributes.size(), 'No gift tribute created.');
	}

	@isTest
	private static void createRecurringGiftTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory().recurringDonationPerson());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);
		StripeResponse.cls_recurrence recur = new StripeResponse.cls_recurrence()
			.parse(stripePayload.data.objectz.metadata.recurrence);

		// * Actual test
		donorService.createRecurringGift(null, person.Id, stripePayload, recur, honoree, match, 'Individual');

		// * Asserts
		List<GiftCommitment> commitment = [SELECT Id FROM GiftCommitment];
		List<GiftCommitmentSchedule> schedule = [SELECT Id FROM GiftCommitmentSchedule];
		List<GiftTransaction> gifts = [SELECT Id FROM GiftTransaction];
		Assert.areEqual(1, gifts.size(), 'No gift transaction created.');
		Assert.areEqual(1, commitment.size(), 'No gift commitment created.');
		Assert.areEqual(1, schedule.size(), 'No gift commitment schedule created.');
	}

	@isTest
	private static void createRecurringGiftWithCampaignAndOSCTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory(camp.Id, osc.Id).recurringDonationPerson());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);
		StripeResponse.cls_recurrence recur = new StripeResponse.cls_recurrence()
			.parse(stripePayload.data.objectz.metadata.recurrence);

		// * Actual test
		donorService.createRecurringGift(org.Id, null, stripePayload, recur, honoree, match, 'Individual');

		// * Asserts
		List<GiftCommitment> commitment = [SELECT Id FROM GiftCommitment];
		List<GiftCommitmentSchedule> schedule = [SELECT Id FROM GiftCommitmentSchedule];
		List<GiftTransaction> gifts = [SELECT Id, CampaignId, OutreachSourceCodeId FROM GiftTransaction];
		Assert.areEqual(1, gifts.size(), 'No gift transaction created.');
		Assert.isNotNull(gifts[0].CampaignId, 'No Campaign Id assigned to gift transaction.');
		Assert.isNotNull(gifts[0].OutreachSourceCodeId, 'No Outreach Source Code Id assigned to gift transaction.');
		Assert.areEqual(1, commitment.size(), 'No gift commitment created.');
		Assert.areEqual(1, schedule.size(), 'No gift commitment schedule created.');
	}

	@isTest
	private static void createBadRecurringGiftTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory(camp.Id, osc.Id).recurringDonationPerson());
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree()
			.parse(stripePayload.data.objectz.metadata.honoree);
		StripeResponse.cls_employer match = new StripeResponse.cls_employer()
			.parse(stripePayload.data.objectz.metadata.match);
		StripeResponse.cls_recurrence recur = new StripeResponse.cls_recurrence()
			.parse(stripePayload.data.objectz.metadata.recurrence);

		// * Actual test
		try {
			donorService.createRecurringGift(org.Id, null, null, recur, honoree, match, 'Individual');
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('An unexpected error occurred in createRecurringGift', exMsg, 'Expected to get an exception.');
	}

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

		// * Actual test
		donorService.handleIncomingInvoice(stripeInvoicePayload, null);

		// * Asserts
		List<GiftTransaction> gifts = [SELECT Id FROM GiftTransaction WHERE stripeId__c != NULL];
		Assert.areEqual(2, gifts.size(), 'Expected to have 2 records with stripe ids.');
	}

	@isTest
	private static void handleIncomingInvoiceNoTransactionTest() {
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

		// * Actual test
		try {
			donorService.handleIncomingInvoice(stripeInvoicePayload, null);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.isTrue(
			exMsg.contains('No Gift Transactions found for Gift Commitment:'),
			'Expected to catch an exception.'
		);
	}

	@isTest
	private static void handleIncomingInvoiceBadSubscriptionIdTest() {
		// * Test data setup
		makeInvoiceData(new StripeTestDataFactory().invoicePerson());

		// * Actual test
		try {
			donorService.handleIncomingInvoice(stripeInvoicePayload, null);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.isTrue(
			exMsg.contains('No Gift Commitment found for Subscription ID:'),
			'Expected to catch an exception.'
		);
	}

	@isTest
	private static void endGiftCommitmentTest() {
		// * Test data setup
		makeCancellationData('sub_123456', new StripeTestDataFactory().cancellation());

		// * Actual test
		donorService.endGiftCommitment(stripeCancellationPayload);

		// * Asserts
		List<GiftCommitment> giftCommitment = [SELECT Id, Status FROM GiftCommitment];
		Assert.areEqual('Closed', giftCommitment[0].Status, 'Commitment should be closed.');
	}

	@isTest
	private static void createOneTimeTicketPaymentTest() {
		// * Test data setup
		MockMultiHttpResponseGenerator mock = new MockMultiHttpResponseGenerator(resStore, matchers, true);
		Test.setMock(HttpCalloutMock.class, mock);
		makeRecordData();

		// * Actual test
		Test.startTest();
		DonationRecordService.createOneTimeGift(person.Id, camp.Id, 'testStripeId', 'Ticket');
		Test.stopTest();

		// * Asserts
		List<GiftTransaction> gifts = [SELECT Id FROM GiftTransaction];
		Assert.areEqual(1, gifts.size(), 'No gifts created');
	}

	@isTest
	private static void createRecurringTicketPaymentTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory(camp.Id, null).recurringTicketPurchase());

		// * Actual test
		DonationRecordService donationService = new DonationRecordService();
		donationService.createRecurringGift(person.Id, camp.Id, stripePayload, 6, 'Ticket');

		// * Asserts
		List<GiftCommitment> giftCommitment = [SELECT Id FROM GiftCommitment];
		List<GiftCommitmentSchedule> giftCommitmentSchedule = [SELECT Id, EndDate FROM GiftCommitmentSchedule];
		List<GiftTransaction> giftTransaction = [SELECT Id FROM GiftTransaction];
		Assert.areEqual(1, giftCommitment.size(), 'No gift commitment created.');
		Assert.areEqual(
			Date.today().addMonths(6),
			giftCommitmentSchedule[0].EndDate,
			'End date not set on commitment schedule.'
		);
		Assert.areEqual(1, giftTransaction.size(), 'No gift transaction created.');
	}

	@isTest
	private static void createZeroDollarTicketTest() {
		// * Test data setup
		makeRecordData();

		// * Actual test
		DonationRecordService donationService = new DonationRecordService();
		donationService.createZeroDollarTicket(person.Id, camp.Id, 1);

		// * Asserts
		List<GiftTransaction> giftTransaction = [SELECT Id FROM GiftTransaction];
		Assert.areEqual(1, giftTransaction.size(), 'No gift transaction created.');
	}

	@isTest
	private static void handleIncomingTicketInvoiceTest() {
		// * Test data setup
		makeRecordData();
		makeCheckoutData(new StripeTestDataFactory(camp.Id, null).recurringTicketPurchase());
		makeInvoiceData(new StripeTestDataFactory().invoiceTicket());

		// * Actual test
		DonationRecordService donationService = new DonationRecordService();
		donationService.createRecurringGift(person.Id, camp.Id, stripePayload, 6, 'Ticket');

		donationService.handleIncomingInvoice(
			stripeInvoicePayload,
			stripeInvoicePayload.data.objectz.subscription_details.metadata
		);

		// * Asserts
		List<GiftTransaction> giftTransaction = [SELECT Id FROM GiftTransaction];
		Assert.areEqual(3, giftTransaction.size(), 'No gift transaction created.');
	}
}
