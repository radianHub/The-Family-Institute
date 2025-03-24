@isTest
private class CampaignServiceTest {
	// # DATA SETUP
	private static CampaignService campService = new CampaignService();
	private static Account acc;
	private static Campaign camp;
	private static String exMsg;

	private static void makeData() {
		acc = (Account) new SObjectBuilder(Account.SObjectType)
			.put(Account.FirstName, 'Test')
			.put(Account.LastName, 'Person')
			.put(
				Account.RecordTypeId,
				Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId()
			)
			.create()
			.getRecord();
		camp = (Campaign) new SObjectBuilder(Campaign.SObjectType).create().getRecord();
	}

	// # UNIT TESTS
	@isTest
	private static void createCampaignMemberTest() {
		// * Test data setup
		makeData();

		// * Actual test
		campService.createCampaignMember(acc.Id, camp.Id);

		// * Asserts
		List<CampaignMember> campMembers = [SELECT Id FROM CampaignMember];
		Assert.areEqual(1, campMembers.size(), 'No Campaign Member created.');
	}

	@isTest
	private static void nullAccountIdTest() {
		// * Test data setup
		makeData();

		// * Actual test
		try {
			campService.createCampaignMember(null, camp.Id);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('Account not available. Cannot create Campaign Member.', exMsg, 'No exception thrown.');
	}

	@isTest
	private static void nullCampaignIdTest() {
		// * Test data setup
		makeData();

		// * Actual test
		try {
			campService.createCampaignMember(acc.Id, null);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('Invalid Campaign or format.', exMsg, 'No exception thrown.');
	}

	@isTest
	private static void badCampaignIdTest() {
		// * Test data setup
		makeData();

		// * Actual test
		try {
			campService.createCampaignMember(acc.Id, 'badCampaignId');
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('Invalid Campaign or format.', exMsg, 'No exception thrown.');
	}

	@isTest
	private static void generateDonationUrlTest() {
		// * Test data setup

		// * Actual test
		Test.startTest();
		camp = (Campaign) new SObjectBuilder(Campaign.SObjectType).create().getRecord();
		camp.Type = 'Event';
		update camp;

		camp.Name = 'Test Event';
		update camp;
		Test.stopTest();

		// * Asserts
		Campaign updatedCamp = [SELECT Id, DonationUrl__c, Type FROM Campaign WHERE Id = :camp.Id];
		System.debug(updatedCamp.Type);
		Assert.isNotNull(updatedCamp.DonationUrl__c, 'Donation URL not generated.');
	}
}
