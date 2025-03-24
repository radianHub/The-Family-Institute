@isTest
private class DonationSelectionControllerTest {
	private static Campaign camp = (Campaign) new SObjectBuilder(Campaign.SObjectType).create().getRecord();
	private static OutreachSourceCode osc = (OutreachSourceCode) new SObjectBuilder(OutreachSourceCode.SObjectType)
		.put(OutreachSourceCode.CampaignId, camp.Id)
		.create()
		.getRecord();
	private static GiftDesignation gd = (GiftDesignation) new SObjectBuilder(GiftDesignation.SObjectType)
		.put(GiftDesignation.isDefault, false)
		.create()
		.getRecord();

	@isTest
	private static void getDonationAmountsTest() {
		List<Donation_Amount__mdt> data = DonationSelectionController.getDonationAmounts();
		System.assert(data.size() > 0, 'No metadata records returned.');
	}

	@isTest
	private static void getSettingsTest() {
		Donation_Component__c data = DonationSelectionController.getSettings();
		System.assert(data != null, 'Donation component custom settings not returned.');
	}

	@isTest
	private static void getProcessingFeeTest() {
		Processing_Fee__c data = DonationSelectionController.getProcessingFee();
		System.assert(data != null, 'Processing fee custom settings not returned.');
	}

	@isTest
	private static void getCampaignTest() {
		Campaign data = DonationSelectionController.getCampaign(camp.Id);
		Assert.isNotNull(data, 'No campaign record returned.');
	}

	@isTest
	private static void getAssociatedFundsByCampaignTest() {
		// * Test data setup
		new SObjectBuilder(GiftDefaultDesignation.SObjectType)
			.put(GiftDefaultDesignation.GiftDesignationId, gd.Id)
			.put(GiftDefaultDesignation.ParentRecordId, camp.Id)
			.create();

		// * Actual test
		List<DonationSelectionController.Fund> funds = DonationSelectionController.getAssociatedFunds(
			camp.Id,
			'campaign'
		);

		// * Asserts
		Assert.isTrue(funds.size() > 0, 'No funds returned.');
	}

	@isTest
	private static void getAssociatedFundsByCampaignNoFundTest() {
		// * Actual test
		List<DonationSelectionController.Fund> funds = DonationSelectionController.getAssociatedFunds(
			camp.Id,
			'campaign'
		);

		// * Asserts
		Assert.isNull(funds, 'Funds returned.');
	}

	@isTest
	private static void getAssociatedFundsByOSCTest() {
		// * Test data setup
		new SObjectBuilder(GiftDefaultDesignation.SObjectType)
			.put(GiftDefaultDesignation.GiftDesignationId, gd.Id)
			.put(GiftDefaultDesignation.ParentRecordId, camp.Id)
			.create();

		// * Actual test
		List<DonationSelectionController.Fund> funds = DonationSelectionController.getAssociatedFunds(osc.Id, 'osc');

		// * Asserts
		Assert.isTrue(funds.size() > 0, 'No funds returned.');
	}

	@isTest
	private static void getAssociatedFundsByOSCNoFundTest() {
		// * Actual test
		List<DonationSelectionController.Fund> funds = DonationSelectionController.getAssociatedFunds(osc.Id, 'osc');

		// * Asserts
		Assert.isNull(funds, 'Funds returned.');
	}

	@isTest
	private static void instantiateEmptyFundTest() {
		// * Test data setup
		DonationSelectionController.Fund fund = new DonationSelectionController.Fund();

		// * Asserts
		Assert.isNull(fund.label);
	}

	@isTest
	private static void createTicketRecordsTest() {
		// * Test data setup
		StripeResponse.cls_payer payer = new StripeResponse.cls_payer();
		payer.firstName = 'Testy';
		payer.lastName = 'Tester';
		payer.email = 'test@test.com';
		payer.phone = '1234567891';
		payer.street = '123 Market St';
		payer.city = 'San Francisco';
		payer.state = 'CA';
		payer.zip = '94104';

		gd.IsDefault = true;
		update gd;

		new SObjectBuilder(GiftDefaultDesignation.SObjectType)
			.put(GiftDefaultDesignation.GiftDesignationId, gd.Id)
			.put(GiftDefaultDesignation.ParentRecordId, camp.Id)
			.create();

		// * Actual test
		DonationSelectionController.createTicketRecords(System.JSON.serialize(payer), camp.Id, 2);

		// * Asserts
		List<Account> acc = [SELECT Id FROM Account];
		List<CampaignMember> campaignMember = [SELECT Id FROM CampaignMember];
		List<GiftTransaction> giftTransaction = [SELECT Id FROM GiftTransaction];
		Assert.areEqual(1, acc.size(), 'No account created.');
		Assert.areEqual(1, campaignMember.size(), 'No campaign member created.');
		Assert.areEqual(2, giftTransaction.size(), 'No gift transactions created.');
	}
}
