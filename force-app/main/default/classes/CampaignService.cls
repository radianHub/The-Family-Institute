public with sharing class CampaignService {
    public void addCampaignMember(String campaignId, Id contactId) {
        if (campaignId == null) return;

        List<CampaignMember> campaignMembers = [
            SELECT Id 
            FROM CampaignMember 
            WHERE CampaignId = :campaignId AND ContactId = :contactId
        ];

        if (campaignMembers.isEmpty()) {
            CampaignMember newMember = new CampaignMember(
                CampaignId = campaignId,
                ContactId = contactId,
                Status = 'Donated'
            );
            insert newMember;
        }
    }
}
