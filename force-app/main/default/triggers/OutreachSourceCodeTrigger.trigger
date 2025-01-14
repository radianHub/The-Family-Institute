trigger OutreachSourceCodeTrigger on OutreachSourceCode(
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	new OutreachSourceCodeTriggerHandler().run();
}
