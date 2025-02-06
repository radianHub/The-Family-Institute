public without sharing class DonationSelectionController {
	@AuraEnabled(cacheable=true)
	public static List<Donation_Amount__mdt> getDonationAmounts() {
		return [
			SELECT
				DeveloperName,
				Auto_Calculate__c,
				Percentage_to_Auto_Calculate__c,
				Starting_Amount__c,
				Giving_Amount_1__c,
				Giving_Amount_2__c,
				Giving_Amount_3__c,
				Giving_Amount_4__c,
				Giving_Amount_5__c,
				Giving_Amount_6__c
			FROM Donation_Amount__mdt
		];
	}

	@AuraEnabled(cacheable=true)
	public static Donation_Component__c getSettings() {
		return Donation_Component__c.getOrgDefaults();
	}

	@AuraEnabled(cacheable=true)
	public static Processing_Fee__c getProcessingFee() {
		return Processing_Fee__c.getOrgDefaults();
	}

	@AuraEnabled(cacheable=true)
	public static List<Fund> getAssociatedFunds(Id campaignOrOscId, String SObjType) {
		List<GiftDefaultDesignation> gds = new List<GiftDefaultDesignation>();
		Set<Fund> funds = new Set<Fund>();
		if (SObjType == 'campaign') {
			gds = [
				SELECT GiftDesignation.Name, GiftDesignationId
				FROM GiftDefaultDesignation
				WHERE ParentRecordId = :campaignOrOscId AND GiftDesignation.isDefault = FALSE
			];
			if (gds.isEmpty()) {
				return null;
			}
		} else if (SObjType == 'osc') {
			Id campaignId;
			try {
				campaignId = [SELECT CampaignId FROM OutreachSourceCode WHERE Id = :campaignOrOscId].CampaignId;

				gds = [
					SELECT GiftDesignation.Name, GiftDesignationId
					FROM GiftDefaultDesignation
					WHERE ParentRecordId = :campaignId AND GiftDesignation.isDefault = FALSE
				];
				if (gds.isEmpty()) {
					return null;
				}
			} catch (Exception ex) {
				throw new AuraException('No campaign associated with this Outreach Source Code');
			}
		}
		for (GiftDefaultDesignation gd : gds) {
			funds.add(new Fund(gd.GiftDesignation.Name, gd.GiftDesignationId));
		}
		return new List<Fund>(funds);
	}

	public class Fund {
		@AuraEnabled
		public String label;
		@AuraEnabled
		public String value;

		public Fund() {
		}
		public Fund(String label, String value) {
			this.label = label;
			this.value = value;
		}
	}
}
