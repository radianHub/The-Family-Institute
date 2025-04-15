/**
 * @Class Name     : OutreachSourceCodeService
 * @Class Purpose  : Handles all database logic for Outreach Source Code records
 * @Author         : Zachary Csotya
 * @Developed On   : 01/13/2025
 * @Last Modified  : 03/24/2025
 **/
public with sharing class OutreachSourceCodeService {
	/**
	 * @description Generates a donation link for a list of Outreach Source Codes
	 * @author Zachary Csotya | 01/13/2025
	 * @param List<OutreachSourceCode> oscs
	 **/
	public static void generateDonationUrl(List<OutreachSourceCode> oscs) {
		Set<OutreachSourceCode> oscsToUpdate = new Set<OutreachSourceCode>();
		String baseURl = StripeIntegrationHelper.getCommunityBaseUrl('Donation1', 'donate');

		Set<Id> campaignIds = Pluck.ids('CampaignId', oscs);

		Map<Id, Campaign> campaigns = new Map<Id, Campaign>([SELECT Id, Type FROM Campaign WHERE Id IN :campaignIds]);

		for (OutreachSourceCode osc : oscs) {
			if (String.isNotBlank(osc.DonationUrl__c)) {
				continue;
			}
			if (campaigns.get(osc.CampaignId).Type != 'Event') {
				osc.DonationUrl__c = baseUrl + '?campaign=' + osc.CampaignId + '&osc=' + osc.Id;
			}
		}
	}
}
