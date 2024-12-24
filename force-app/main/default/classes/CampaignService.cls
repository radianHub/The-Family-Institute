public without sharing class CampaignService {
	/**
	 * Creates a CampaignMember record for the specified Account and Campaign if it does not already exist.
	 * @param recordId - The ID of the Account to link as a Campaign Member.
	 * @param campaignId - The ID of the Campaign to associate with the Contact.
	 * @throws DonationProcessingException - if there is an issue with creating the Campaign Member.
	 */
	public void createCampaignMember(Id recordId, String campaignId) {
		// Validate input parameters
		if (recordId == null) {
			throw new DonationProcessingException('Account not available. Cannot create Campaign Member.');
		}
		if (String.isBlank(campaignId) || !Pattern.matches('[a-zA-Z0-9]{15,18}', campaignId)) {
			throw new DonationProcessingException('Invalid Campaign or format.');
		}

		Id memberId;
		try {
			// Check if CampaignMember already exists
			memberId = [
				SELECT Id
				FROM CampaignMember
				WHERE CampaignId = :campaignId AND ContactId = :recordId
				LIMIT 1
			]
			.Id;
		} catch (Exception ex) {
			System.debug('No existing Campaign Member found, creating new.');

			// Create new campaign member
			CampaignMember newMember = new CampaignMember(
				CampaignId = campaignId,
				ContactId = recordId,
				Status = 'Donated'
			);
			// Insert Campaign Member
			memberId = StripeIntegrationHelper.dbInsert(newMember);
		}
	}
}
