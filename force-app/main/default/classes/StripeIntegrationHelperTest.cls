@isTest
private class StripeIntegrationHelperTest {
	// # DATA SETUP
	private static Contact con = (Contact) new SObjectBuilder(Contact.SObjectType).build().getRecord();
	private static GiftTransaction gift = (GiftTransaction) new SObjectBuilder(GiftTransaction.SObjectType)
		.put(GiftTransaction.stripeId__c, '123456')
		.build()
		.getRecord();

	// # UNIT TESTS
	@isTest
	private static void insertRecordTest() {
		// * Actual test
		String id = StripeIntegrationHelper.dbInsert(con);

		// * Asserts
		Assert.isNotNull(id, 'Record not created.');
	}

	@isTest
	private static void insertRecordErrorTest() {
		// * Test data setup
		String exMsg;

		// * Actual test
		try {
			StripeIntegrationHelper.dbInsert(gift, GiftTransaction.stripeId__c);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.isNotNull(exMsg, 'Expected to receive an exception.');
	}

	@isTest
	private static void insertRecordWithExternalIdTest() {
		// * Test data setup
		gift.Name = 'Test Gift';
		gift.PaymentMethod = 'Unknown';
		gift.OriginalAmount = 100;

		// * Actual test
		String id = StripeIntegrationHelper.dbInsert(gift, GiftTransaction.stripeId__c);

		// * Asserts
		Assert.isNotNull(id, 'Record not created.');
	}

	@isTest
	private static void getAmountWithCentsTest() {
		// * Test data setup
		Decimal amt1 = 125;
		Decimal amt2 = 145.60;

		// * Actual test
		String amt1Str = StripeIntegrationHelper.getAmountWithCents(amt1);
		String amt2Str = StripeIntegrationHelper.getAmountWithCents(amt2);

		// * Asserts
		Assert.areEqual('125.00', amt1Str, 'Amount 1 should be converted to a string with cents.');
		Assert.areEqual('145.60', amt2Str, 'Amount 2 should be converted to a string with cents.');
	}
}
