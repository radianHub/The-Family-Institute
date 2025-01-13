/**
 * @Class Name     : AccountService
 * @Class Purpose  : Handles all database logic for Account records.
 * @Author         : Zachary Csotya
 * @Developed On   : 12/31/2024
 * @Last Modified  : 12/31/2024
 **/
public without sharing class AccountService {
	final static Id PERSON_ACCT_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
		.get('PersonAccount')
		.getRecordTypeId();

	final static Id ORG_ACCT_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
		.get('Organization')
		.getRecordTypeId();

	/**
	 * @description Retrieves the id of a person account by given email, if person not found creates a new person account record.
	 * @author Zachary Csotya | 12/30/2024
	 * @param StripeResponse.cls_customer_details customerDetails
	 * @return Id
	 **/
	public Id getOrCreatePersonAccount(StripeResponse.cls_customer_details customerDetails) {
		if (customerDetails == null || String.isBlank(customerDetails.email)) {
			throw new DonationProcessingException('Customer details or email is null');
		}

		try {
			// * Query for existing account by email
			return [SELECT Id, Name FROM Account WHERE PersonEmail = :customerDetails.email LIMIT 1].Id;
		} catch (Exception ex) {
			System.debug('No existing account found, creating new.');

			// * Parse customer name into first and last names
			String firstName, lastName;
			try {
				Map<String, String> nameParts = parseName(customerDetails.name);
				firstName = nameParts.get('firstName');
				lastName = nameParts.get('lastName');
			} catch (Exception e) {
				throw new DonationProcessingException('Failed to parse customer name: ' + customerDetails.name, e);
			}

			// * Create new person account
			return parseRecordData(
				new AccountData(
					firstName,
					lastName,
					customerDetails.email,
					String.isNotBlank(customerDetails.phone) ? customerDetails.phone.removeStart('+1') : null,
					String.join(
						new List<String>{
							customerDetails.address.line1,
							customerDetails.address.line2 != null ? customerDetails.address.line2 : ''
						},
						' '
					),
					customerDetails.address.city,
					customerDetails.address.state,
					customerDetails.address.postal_code,
					customerDetails.address.country,
					'Donor'
				),
				true
			);
		}
	}

	/**
	 * @description Retrieves the id of an organization account by given phone, if org not found creates a new org account record.
	 * @author Zachary Csotya | 12/30/2024
	 * @param StripeResponse.cls_customer_details customer
	 * @param StripeResponse.cls_organization org
	 * @return Map<String, Id>
	 **/
	public Map<String, Id> getOrCreateOrgAccount(
		StripeResponse.cls_customer_details customer,
		StripeResponse.cls_organization org
	) {
		if (org.orgInfo == null || String.isBlank(org.orgInfo.Phone)) {
			throw new DonationProcessingException('Org details or phone is null');
		}

		Id accId;
		try {
			// * Query for existing account by email
			accId = [SELECT Id, Name FROM Account WHERE Phone = :org.orgInfo.Phone LIMIT 1].Id;
		} catch (Exception accEx) {
			System.debug('No existing account found, creating new.');

			// * Create new org account
			accId = parseRecordData(
				new AccountData(
					null,
					org.orgInfo.orgName,
					null,
					org.orgInfo.Phone,
					org.orgInfo.Street,
					org.orgInfo.City,
					org.orgInfo.State,
					org.orgInfo.Zip,
					null,
					'Other'
				),
				false
			);
		}

		// * Get or create person account
		Id personId = getOrCreatePersonAccount(customer);
		Id conId = [SELECT Id FROM Contact WHERE AccountId = :personId].Id;
		AccountContactRelation accConRelation;
		// * Look for existing AccountContactRelation, if none exists creates new
		try {
			accConRelation = [SELECT Id FROM AccountContactRelation WHERE AccountId = :accId AND ContactId = :conId];
		} catch (Exception ex) {
			accConRelation = new AccountContactRelation(AccountId = accId, ContactId = conId);
			insert accConRelation;
		}
		return new Map<String, Id>{ 'person' => personId, 'org' => accId };
	}

	// ! This method is not used in the current implementation
	/**
	 * @description Retrieves the id of an organization account by given account name, if org not found creates a new org account record.
	 * @author Zachary Csotya | 12/30/2024
	 * @param StripeResponse.cls_customer_details customer
	 * @param StripeResponse.cls_employer match
	 * @return Id
	 **/
	// public Id getOrCreateOrgAccount(StripeResponse.cls_customer_details customer, StripeResponse.cls_employer match) {
	// 	if (match.employerInfo == null || String.isBlank(match.employerInfo.employerName)) {
	// 		throw new DonationProcessingException('Employer details are null');
	// 	}

	// 	Id accId;
	// 	try {
	// 		// Query for existing account by email
	// 		accId = [SELECT Id, Name FROM Account WHERE Name = :match.employerInfo.employerName LIMIT 1].Id;
	// 	} catch (Exception accEx) {
	// 		System.debug('No existing account found, creating new.');

	// 		// Create new org account
	// 		accId = parseRecordData(
	// 			new AccountData(
	// 				null,
	// 				match.employerInfo.employerName,
	// 				null,
	// 				null,
	// 				null,
	// 				null,
	// 				null,
	// 				null,
	// 				null,
	// 				'Other'
	// 			),
	// 			false
	// 		);
	// 	}

	// 	Id personId = getOrCreatePersonAccount(customer);
	// 	Id conId = [SELECT Id FROM Contact WHERE AccountId = :personId].Id;
	// 	AccountContactRelation accConRelation;
	// 	try {
	// 		accConRelation = [SELECT Id FROM AccountContactRelation WHERE AccountId = :accId AND ContactId = :conId];
	// 	} catch (Exception ex) {
	// 		accConRelation = new AccountContactRelation(AccountId = accId, ContactId = conId);
	// 		insert accConRelation;
	// 	}
	// 	return accId;
	// }

	// ! This method is not used in the current implementation
	/**
	 * @description Retrieves the id of an honoree person account by given email, if honoree not found creates a new person account record.
	 * @author Zachary Csotya | 12/30/2024
	 * @param StripeResponse.cls_honoree honoree
	 * @return Id
	 **/
	// public Id getOrCreateHonoree(StripeResponse.cls_honoree honoree) {
	// 	if (honoree == null) {
	// 		return null;
	// 	}

	// 	try {
	// 		return [
	// 			SELECT Id, Name
	// 			FROM Account
	// 			WHERE PersonEmail = :honoree.honoreeInfo.Email AND PersonEmail != NULL
	// 			LIMIT 1
	// 		]
	// 		.Id;
	// 	} catch (Exception ex) {
	// 		System.debug('No existing account found, creating new.');

	// 		return parseRecordData(
	// 			new AccountData(
	// 				honoree.honoreeInfo.FirstName,
	// 				honoree.honoreeInfo.LastName,
	// 				honoree.honoreeInfo.Email,
	// 				honoree.honoreeInfo.Phone,
	// 				honoree.honoreeInfo.Street,
	// 				honoree.honoreeInfo.City,
	// 				honoree.honoreeInfo.State,
	// 				honoree.honoreeInfo.Zip,
	// 				null,
	// 				'Other'
	// 			),
	// 			true
	// 		);
	// 	}
	// }

	/**
	 * @description Creates new organization or person account records from the given data.
	 * @author Zachary Csotya | 12/30/2024
	 * @param AccountData data
	 * @param Boolean person
	 * @return Id
	 **/
	private Id parseRecordData(AccountData data, Boolean person) {
		Account newAcc;
		if (person) {
			newAcc = new Account(
				RecordTypeId = PERSON_ACCT_RT,
				FirstName = data.fName,
				LastName = data.lName,
				PersonEmail = data.email,
				Type = data.accType,
				PersonMobilePhone = data.phone,
				PersonMailingCity = data.city,
				PersonMailingCountry = data.country,
				PersonMailingPostalCode = data.zip,
				PersonMailingState = data.state,
				PersonMailingStreet = data.street
			);
		} else {
			newAcc = new Account(
				RecordTypeId = ORG_ACCT_RT,
				Name = data.lName,
				Phone = data.phone,
				BillingCity = data.city,
				BillingState = data.state,
				BillingPostalCode = data.zip,
				BillingStreet = data.street,
				Type = data.accType
			);
		}

		// Insert Account
		return StripeIntegrationHelper.dbInsert(newAcc);
	}

	/**
	 * @description Generates a map of first and last name from the given full name.
	 * @author Zachary Csotya | 12/30/2024
	 * @param String fullName
	 * @return Map<String, String>
	 **/
	private Map<String, String> parseName(String fullName) {
		if (String.isBlank(fullName)) {
			throw new DonationProcessingException('Customer name is blank');
		}
		List<String> nameParts = fullName.split(' ');
		String firstName = nameParts[0];
		String lastName = nameParts.size() > 1 ? nameParts[nameParts.size() - 1] : firstName;
		return new Map<String, String>{ 'firstName' => firstName, 'lastName' => lastName };
	}

	private class AccountData {
		String fName;
		String lName;
		String email;
		String phone;
		String street;
		String city;
		String state;
		String zip;
		String country;
		String accType;

		private AccountData(
			String firstName,
			String lastName,
			String email,
			String phone,
			String street,
			String city,
			String state,
			String zip,
			String country,
			String accType
		) {
			this.fName = firstName;
			this.lName = lastName;
			this.email = email;
			this.phone = phone;
			this.street = street;
			this.city = city;
			this.state = state;
			this.zip = zip;
			this.country = country;
			this.accType = accType;
		}
	}
}
