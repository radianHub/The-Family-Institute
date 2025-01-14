public with sharing class OutreachSourceCodeTriggerHandler extends TriggerHandler {
	List<OutreachSourceCode> newList;
	Map<Id, OutreachSourceCode> newMap;
	List<OutreachSourceCode> oldList;
	Map<Id, OutreachSourceCode> oldMap;

	public OutreachSourceCodeTriggerHandler() {
		this.newList = (List<OutreachSourceCode>) Trigger.new;
		this.newMap = (Map<Id, OutreachSourceCode>) Trigger.newMap;
		this.oldList = (List<OutreachSourceCode>) Trigger.old;
		this.oldMap = (Map<Id, OutreachSourceCode>) Trigger.oldMap;
	}

	public static Boolean triggerExecuting = false;

	public override void afterInsert() {
		if (!triggerExecuting) {
			// triggerExecuting = true;
			OutreachSourceCodeService.generateDonationUrl(newList);
		}
	}

	public override void afterUpdate() {
		if (!triggerExecuting) {
			triggerExecuting = true;
			OutreachSourceCodeService.generateDonationUrl(newList);
		}
	}
}
