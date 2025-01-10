/**
 * @Class Name     : CampaignService
 * @Class Purpose  : Handles all database logic for Campaign records.
 * @Author         : Zachary Csotya
 * @Developed On   : 12/30/2024
 * @Last Modified  : 12/30/2024
 **/
public without sharing class CampaignService {
	/**
	 * @description Creates a CampaignMember record for the specified Account and Campaign if it does not already exist.
	 * @author Zachary Csotya | 12/30/2024
	 * @param Id recordId
	 * @param String campaignId
	 **/
	public void createCampaignMember(Id recordId, String campaignId) {
		// * Validate input parameters
		if (recordId == null) {
			throw new DonationProcessingException('Account not available. Cannot create Campaign Member.');
		}
		if (String.isBlank(campaignId) || !Pattern.matches('[a-zA-Z0-9]{15,18}', campaignId)) {
			throw new DonationProcessingException('Invalid Campaign or format.');
		}

		Contact con = [
			SELECT Id
			FROM Contact
			WHERE AccountId = :recordId
		];

		Id memberId;
		try {
			// * Check if CampaignMember already exists
			memberId = [
				SELECT Id
				FROM CampaignMember
				WHERE CampaignId = :campaignId AND ContactId = :con.Id
				LIMIT 1
			]
			.Id;
		} catch (Exception ex) {
			System.debug('No existing Campaign Member found, creating new.');

			// * Create new campaign member
			CampaignMember newMember = new CampaignMember(
				CampaignId = campaignId,
				ContactId = con.Id,
				Status = 'Donated'
			);
			// * Insert Campaign Member
			memberId = StripeIntegrationHelper.dbInsert(newMember);
		}
	}
}
