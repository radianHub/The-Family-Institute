@isTest
private class StripeCancellationCallbackResourceTest {
	// # DATA SETUP
	private static RestRequest req;
	private static RestResponse res;

	private static void buildRestContext(Blob requestBody) {
		req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestURI = '/services/apexrest/invoice';
		req.requestBody = requestBody;
		RestContext.request = req;

		res = new RestResponse();
		RestContext.response = res;
	}

	private static void makeData(String stripeSubId) {
		GiftCommitment gift = (GiftCommitment) new SObjectBuilder(GiftCommitment.SObjectType)
			.put(GiftCommitment.StripeSubscriptionId__c, stripeSubId)
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
	}

	// # UNIT TESTS
	@isTest
	private static void cancelGiftCommitmentTest() {
		// * Test data setup
		makeData('sub_123456');
		buildRestContext(new StripeTestDataFactory().cancellation());

		// * Actual test
		StripeCancellationCallbackResource.doPost();

		// * Asserts
		Assert.areEqual(204, res.statusCode, 'Expected status code 204.');
	}

	@isTest
	private static void badRequestTest() {
		// * Test data setup
		buildRestContext(null);

		// * Actual test
		StripeCancellationCallbackResource.doPost();

		// * Asserts
		Assert.areEqual(400, res.statusCode, 'Expected status code 400.');
	}

	@isTest
	private static void noCommitmentTest() {
		// * Test data setup
		buildRestContext(new StripeTestDataFactory().cancellation());

		// * Actual test
		StripeCancellationCallbackResource.doPost();

		// * Asserts
		Assert.areEqual(500, res.statusCode, 'Expected status code 500.');
	}
}
