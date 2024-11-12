public without sharing class CampaignService {
	/**
	 * Creates a CampaignMember record for the specified Contact and Campaign if it does not already exist.
	 * @param contactId - The ID of the Contact to link as a Campaign Member.
	 * @param campaignId - The ID of the Campaign to associate with the Contact.
	 * @throws DonationProcessingException - if there is an issue with creating the Campaign Member.
	 */
	public void createCampaignMember(Id contactId, String campaignId) {
		// Validate input parameters
		if (contactId == null) {
			throw new DonationProcessingException('Contact ID is null. Cannot create Campaign Member.');
		}
		if (String.isBlank(campaignId) || !Pattern.matches('[a-zA-Z0-9]{15,18}', campaignId)) {
			throw new DonationProcessingException('Invalid Campaign ID format or ID is null.');
		}

		// Check if CampaignMember already exists
		List<CampaignMember> members = [
			SELECT Id
			FROM CampaignMember
			WHERE CampaignId = :campaignId AND ContactId = :contactId
			LIMIT 1
		];

		if (members.isEmpty()) {
			CampaignMember newMember = new CampaignMember(
				CampaignId = campaignId,
				ContactId = contactId,
				Status = 'Donated'
			);

			try {
				insert newMember;
			} catch (DmlException e) {
				throw new DonationProcessingException(
					'Failed to create Campaign Member for Contact: ' + contactId + ' and Campaign: ' + campaignId,
					e
				);
			}
		}
	}
}
