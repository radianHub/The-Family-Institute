public without sharing class StripeIntegrationHelper {
	public static Id dbInsert(SObject record) {
		return dbInsert(new List<SObject>{ record })[0];
	}
	public static Id dbInsert(SObject record, Schema.SObjectField externalId) {
		return dbInsert(new List<SObject>{ record }, externalId)[0];
	}

	public static List<Id> dbInsert(List<SObject> records) {
		Database.UpsertResult[] srL = Database.upsert(records, false);
		return performDML(records, srL);
	}

	public static List<Id> dbInsert(List<SObject> records, Schema.SObjectField externalId) {
		Database.UpsertResult[] srL = Database.upsert(records, externalId, false);
		return performDML(records, srL);
	}

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

	public static String getAmountWithCents(Decimal amt) {
		String amtString = amt.toPlainString();
		if (amtString.contains('.')) {
			return amtString;
		} else {
			return amtString + '.00';
		}
	}
}
