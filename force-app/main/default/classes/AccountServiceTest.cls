@isTest
private class AccountServiceTest {
	// # DATA SETUP
	private static StripeResponse stripePayload;
	private static AccountService accService = new AccountService();
	private static String exMsg;

	private static void makePersonData() {
		StripeTestDataFactory stf = new StripeTestDataFactory();
		String stripeResponse = stf.oneTimeDonationPerson().toString().replace('object', 'objectz');
		System.debug(stripeResponse);
		stripePayload = (StripeResponse) System.JSON.deserialize(stripeResponse, StripeResponse.class);
	}
	private static void makeOrgData() {
		StripeTestDataFactory stf = new StripeTestDataFactory();
		String stripeResponse = stf.oneTimeDonationOrg().toString().replace('object', 'objectz');
		System.debug(stripeResponse);
		stripePayload = (StripeResponse) System.JSON.deserialize(stripeResponse, StripeResponse.class);
	}

	// # UNIT TESTS
	@isTest
	private static void getOrCreatePersonAccountTest() {
		// * Test data setup
		makePersonData();

		// * Actual test
		Id accId = accService.getOrCreatePersonAccount(stripePayload.data.objectz.customer_details);

		// * Asserts
		Assert.isNotNull(accId, 'No account ID returned.');
	}

	@isTest
	private static void nullPersonNameTest() {
		// * Test data setup
		makePersonData();
		StripeResponse.cls_customer_details customerDetails = stripePayload.data.objectz.customer_details;
		customerDetails.name = null;

		// * Actual test
		try {
			Id accId = accService.getOrCreatePersonAccount(stripePayload.data.objectz.customer_details);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('Failed to parse customer name: null', exMsg, 'No exception thrown.');
	}

	@isTest
	private static void nullCustomerDetailsTest() {
		// * Test data setup

		// * Actual test
		try {
			accService.getOrCreatePersonAccount(null);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('Customer details or email is null', exMsg, 'No exception thrown.');
	}

	@isTest
	private static void nullCustomerEmailTest() {
		// * Test data setup
		makePersonData();
		StripeResponse.cls_customer_details customerDetails = stripePayload.data.objectz.customer_details;
		customerDetails.email = null;

		// * Actual test
		try {
			accService.getOrCreatePersonAccount(customerDetails);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('Customer details or email is null', exMsg, 'message');
	}

	@isTest
	private static void getOrCreateOrgAccountTest() {
		// * Test data setup
		makeOrgData();
		StripeResponse.cls_customer_details customerDetails = stripePayload.data.objectz.customer_details;
		StripeResponse.cls_organization org = new StripeResponse.cls_organization()
			.parse(stripePayload.data.objectz.metadata.organization);

		// * Actual test
		Map<String, Id> accIds = accService.getOrCreateOrgAccount(customerDetails, org);

		// * Asserts
		Assert.isNotNull(accIds.get('org'), 'No org account created');
		Assert.isNotNull(accIds.get('person'), 'No person account created');
	}

	@isTest
	private static void nullOrgPhoneTest() {
		// * Test data setup
		makeOrgData();
		StripeResponse.cls_customer_details customerDetails = stripePayload.data.objectz.customer_details;
		StripeResponse.cls_organization org = new StripeResponse.cls_organization()
			.parse(stripePayload.data.objectz.metadata.organization);
		org.orgInfo.Phone = null;

		// * Actual test
		try {
			Map<String, Id> accIds = accService.getOrCreateOrgAccount(customerDetails, org);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('Org details or phone is null', exMsg, 'No exception thrown.');
	}

	@isTest
	private static void nullOrgInfoTest() {
		// * Test data setup
		makeOrgData();
		StripeResponse.cls_customer_details customerDetails = stripePayload.data.objectz.customer_details;
		StripeResponse.cls_organization org = new StripeResponse.cls_organization()
			.parse(stripePayload.data.objectz.metadata.organization);
		org.orgInfo = null;

		// * Actual test
		try {
			Map<String, Id> accIds = accService.getOrCreateOrgAccount(customerDetails, org);
		} catch (Exception ex) {
			exMsg = ex.getMessage();
		}

		// * Asserts
		Assert.areEqual('Org details or phone is null', exMsg, 'No exception thrown.');
	}
}
