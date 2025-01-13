@isTest
private class OutreachSourceCodeServiceTest {
	// # DATA SETUP

	// # UNIT TESTS
	@isTest
	private static void generateDonationUrlTestTest() {
		// * Test data setup
		new SObjectBuilder(OutreachSourceCode.SObjectType).create().getRecord();

		// * Actual test
		OutreachSourceCode updatedOSC = [SELECT Id, DonationUrl__c FROM OutreachSourceCode];

		// * Asserts
		Assert.isNotNull(updatedOSC.DonationUrl__c, 'Donation URL not generated.');
	}
}
