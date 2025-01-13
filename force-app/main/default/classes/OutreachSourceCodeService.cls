/**
 * @Class Name     : OutreachSourceCodeService
 * @Class Purpose  : Handles all database logic for Outreach Source Code records
 * @Author         : Zachary Csotya
 * @Developed On   : 01/13/2025
 * @Last Modified  : 01/13/2025
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

		for (OutreachSourceCode osc : oscs) {
			if (String.isNotBlank(osc.DonationUrl__c)) {
				continue;
			}
			oscsToUpdate.add(
				new OutreachSourceCode(
					Id = osc.Id,
					DonationUrl__c = baseUrl + '?campaign=' + osc.CampaignId + '&osc=' + osc.Id
				)
			);
		}
		update new List<OutreachSourceCode>(oscsToUpdate);
	}
}
