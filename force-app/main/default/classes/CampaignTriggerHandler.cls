public with sharing class CampaignTriggerHandler extends TriggerHandler {
	List<Campaign> newList;
	Map<Id, Campaign> newMap;
	List<Campaign> oldList;
	Map<Id, Campaign> oldMap;

	public CampaignTriggerHandler() {
		this.newList = (List<Campaign>) Trigger.new;
		this.newMap = (Map<Id, Campaign>) Trigger.newMap;
		this.oldList = (List<Campaign>) Trigger.old;
		this.oldMap = (Map<Id, Campaign>) Trigger.oldMap;
	}

	public static Boolean triggerExecuting = false;

	public override void afterInsert() {
		CampaignService.generateDonationUrl(newList, null);
	}

	public override void afterUpdate() {
		if (!triggerExecuting) {
			triggerExecuting = true;
			CampaignService.generateDonationUrl(newList);
		}
	}
}
