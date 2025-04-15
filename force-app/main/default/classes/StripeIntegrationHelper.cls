/**
 * @Class Name     : StripeIntegrationHelper
 * @Class Purpose  : Provides helper methods for Stripe integration.
 * @Author         : Zachary Csotya
 * @Developed On   : 01/13/2025
 * @Last Modified  : 03/12/2025
 **/
public without sharing class StripeIntegrationHelper {
	/**
	 * @description Inserts a single record.
	 * @author Zachary Csotya | 01/13/2025
	 * @param SObject record
	 * @return Id
	 **/
	public static Id dbInsert(SObject record) {
		return dbInsert(new List<SObject>{ record })[0];
	}
	/**
	 * @description Inserts a single record with an external id.
	 * @author Zachary Csotya | 01/13/2025
	 * @param SObject record
	 * @param Schema.SObjectField externalId
	 * @return Id
	 **/
	public static Id dbInsert(SObject record, Schema.SObjectField externalId) {
		return dbInsert(new List<SObject>{ record }, externalId)[0];
	}

	/**
	 * @description Inserts a list of records.
	 * @author Zachary Csotya | 01/13/2025
	 * @param List<SObject> records
	 * @return List<Id>
	 **/
	public static List<Id> dbInsert(List<SObject> records) {
		Database.UpsertResult[] srL = Database.upsert(records, false);
		return performDML(records, srL);
	}

	/**
	 * @description Inserts a list of records with external ids.
	 * @author Zachary Csotya | 01/13/2025
	 * @param List<SObject> records
	 * @param Schema.SObjectField externalId
	 * @return List<Id>
	 **/
	public static List<Id> dbInsert(List<SObject> records, Schema.SObjectField externalId) {
		Database.UpsertResult[] srL = Database.upsert(records, externalId, false);
		return performDML(records, srL);
	}

	/**
	 * @description Performs a database upsert on a list of records and handles errors.
	 * @author Zachary Csotya | 01/13/2025
	 * @param List<SObject> records
	 * @param List<Database.UpsertResult> urL
	 * @return List<Id>
	 **/
	private static List<Id> performDML(List<SObject> records, List<Database.UpsertResult> urL) {
		Set<Id> returnIds = new Set<Id>();
		for (Database.UpsertResult ur : urL) {
			if (!ur.isSuccess()) {
				for (Database.Error err : ur.getErrors()) {
					throw new DonationProcessingException(
						'Failed to create new ' +
							String.valueOf(records[0].getSObjectType()) +
							':' +
							'\n Error message :: ' +
							err.getMessage() +
							'.\n Affected fields :: ' +
							err.getFields()
					);
				}
			}
			returnIds.add(ur.getId());
		}
		return new List<Id>(returnIds);
	}

	/**
	 * @description Generates a formatted string from a decimal with cents.
	 * @author Zachary Csotya | 01/13/2025
	 * @param Decimal amt
	 * @return String
	 **/
	public static String getAmountWithCents(Decimal amt) {
		String amtString = amt.toPlainString();
		if (amtString.contains('.')) {
			return amtString;
		} else {
			return amtString + '.00';
		}
	}

	/**
	 * @description Generates a url for a community page.
	 * @author Zachary Csotya | 01/13/2025
	 * @param String communityName
	 * @param String page
	 * @return String
	 **/
	public static String getCommunityBaseUrl(String communityName, String page) {
		Site site;
		try {
			site = [SELECT Id FROM Site WHERE Name = :communityName];
		} catch (Exception ex) {
			throw new DonationProcessingException('No Site record found.');
		}
		return [SELECT SecureURL FROM SiteDetail WHERE DurableId = :site.Id].SecureUrl + page;
	}

	/**
	 * @description Makes a callout to stripe to get checkout session line items
	 * @author Zachary Csotya | 03/12/2025
	 * @param String sessionId
	 * @return StripeIntegrationHelper.SessionLineItem
	 **/
	public static StripeIntegrationHelper.SessionLineItem getSessionLineItems(String sessionId) {
		Donation_Component__c donationSettings = Donation_Component__c.getOrgDefaults();

		HttpRequest req = new HttpRequest();
		req.setEndpoint(donationSettings.Endpoint__c + '/v1/checkout/sessions/' + sessionId + '/line_items');
		req.setHeader('Authorization', 'Bearer ' + donationSettings.Stripe_API_Key__c);
		req.setMethod('GET');
		HttpResponse res = new Http().send(req);

		String resBody = res.getBody().toString().replaceAll('object', 'objectz');
		resBody = resBody.replaceAll('currency', 'currencyz');

		return (SessionLineItem) System.JSON.deserialize(resBody, SessionLineItem.class);
	}

	public class SessionLineItem {
		public String objectz;
		public List<LineItemData> data;
		public Boolean has_more;
		public String url;
	}

	public class LineItemData {
		public String id;
		public String objectz;
		public Integer amount_discount;
		public Integer amount_subtotal;
		public Integer amount_tax;
		public Integer amount_total;
		public String currencyz;
		public String description;
		public StripeInvoiceResponse.cls_price price;
		public Integer quantity;
	}
}
