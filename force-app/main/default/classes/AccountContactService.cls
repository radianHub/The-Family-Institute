public without sharing class AccountContactService {
	public Contact getOrCreateContact(StripeResponse.cls_customer_details customerDetails) {
		if (customerDetails == null || String.isBlank(customerDetails.email)) {
			throw new DonationProcessingException('Customer details or email is null');
		}

		// Step 1: Query for existing contact by email
		List<Contact> contacts = [SELECT Id, AccountId, Name FROM Contact WHERE Email = :customerDetails.email LIMIT 1];
		if (!contacts.isEmpty()) {
			Contact existingContact = contacts[0];
			if (existingContact.AccountId == null) {
				throw new DonationProcessingException(
					'Existing contact has no associated account: ' + existingContact.Name
				);
			}
			return existingContact;
		}

		// Step 2: Parse customer name into first and last names
		String firstName, lastName;
		try {
			Map<String, String> nameParts = parseName(customerDetails.name);
			firstName = nameParts.get('firstName');
			lastName = nameParts.get('lastName');
		} catch (Exception e) {
			throw new DonationProcessingException('Failed to parse customer name: ' + customerDetails.name, e);
		}

		// Step 3: Create a new Household Account (or other account type as needed)
		Account householdAccount = new Account(
			Name = firstName + ' ' + lastName + ' Household',
			RecordTypeId = getHouseholdRecordTypeId()
		);

		// Step 4: Create the new contact linked to the household account
		Contact newContact = new Contact(
			AccountId = householdAccount.Id,
			FirstName = firstName,
			LastName = lastName,
			Email = customerDetails.email,
			Phone = String.isNotBlank(customerDetails.phone) ? customerDetails.phone.removeStart('+1') : null,
			MailingCity = customerDetails.address.city,
			MailingCountry = customerDetails.address.country,
			MailingPostalCode = customerDetails.address.postal_code,
			MailingState = customerDetails.address.state,
			MailingStreet = String.join(
				new List<String>{
					customerDetails.address.line1,
					customerDetails.address.line2 != null ? customerDetails.address.line2 : ''
				},
				' '
			)
		);

		// Step 5: Insert Account and Contact within a single transaction
		try {
			insert new List<SObject>{ householdAccount, newContact };
		} catch (DmlException e) {
			throw new DonationProcessingException(
				'Failed to create Account and Contact for: ' + firstName + ' ' + lastName,
				e
			);
		}

		return newContact;
	}

	// Helper method to parse full name into first and last name
	private Map<String, String> parseName(String fullName) {
		if (String.isBlank(fullName)) {
			throw new DonationProcessingException('Customer name is blank');
		}
		List<String> nameParts = fullName.split(' ');
		String firstName = nameParts[0];
		String lastName = nameParts.size() > 1 ? nameParts[nameParts.size() - 1] : firstName;
		return new Map<String, String>{ 'firstName' => firstName, 'lastName' => lastName };
	}

	// Cache RecordTypeId for Household and handle exceptions
	private static Id householdRecordTypeId;
	private Id getHouseholdRecordTypeId() {
		if (householdRecordTypeId == null) {
			try {
				householdRecordTypeId = [
					SELECT Id
					FROM RecordType
					WHERE SObjectType = 'Account' AND DeveloperName = 'Household'
					LIMIT 1
				]
				.Id;
			} catch (QueryException e) {
				throw new DonationProcessingException('Household RecordType not found for Account', e);
			}
		}
		return householdRecordTypeId;
	}
}
