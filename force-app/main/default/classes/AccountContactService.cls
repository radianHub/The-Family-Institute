public with sharing class AccountContactService {
    public Contact findOrCreateContact(StripeCustomerDetails customerDetails) {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :customerDetails.email];
        
        if (!contacts.isEmpty()) {
            return contacts[0];
        }

        Contact newContact = new Contact(
            FirstName = extractFirstName(customerDetails.name),
            LastName = extractLastName(customerDetails.name),
            Email = customerDetails.email,
            Phone = customerDetails.phone,
            MailingStreet = customerDetails.address.line1,
            MailingCity = customerDetails.address.city,
            MailingState = customerDetails.address.state,
            MailingPostalCode = customerDetails.address.postal_code,
            MailingCountry = customerDetails.address.country
        );
        insert newContact;

        return newContact;
    }

    private String extractFirstName(String fullName) {
        return fullName.split(' ')[0];
    }

    private String extractLastName(String fullName) {
        List<String> parts = fullName.split(' ');
        return parts[parts.size() - 1];
    }
}
