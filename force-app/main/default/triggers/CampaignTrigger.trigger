trigger CampaignTrigger on Campaign(
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	new CampaignTriggerHandler().run();
}
