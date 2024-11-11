public with sharing class DonationRecordService {
    public void createGiftTransaction(StripeResponse data, Contact donor) {
        // Create a GiftTransaction record
        GiftTransaction giftTransaction = new GiftTransaction(
            OriginalAmount__c = Decimal.valueOf(data.data.objectz.amount_total) / 100,
            GiftType__c = data.data.objectz.metadata.anonymous == 'true' ? 'Anonymous' : 'Individual',
            DonorContact__c = donor.Id,
            Campaign__c = data.data.objectz.metadata.campaignId
        );

        if (data.data.objectz.metadata.honoree != null) {
            createGiftTribute(data, giftTransaction);
        }
        
        insert giftTransaction;
    }

    public void createRecurringDonation(StripeResponse data, Contact donor) {
        // Create a GiftCommitment and associated GiftCommitmentSchedule
        GiftCommitment commitment = new GiftCommitment(
            Amount__c = Decimal.valueOf(data.data.objectz.amount_total) / 100,
            DonorContact__c = donor.Id,
            Interval__c = data.data.objectz.metadata.recurrence.interval,
            IntervalCount__c = Integer.valueOf(data.data.objectz.metadata.recurrence.intervalCount)
        );
        insert commitment;
        
        // Create a GiftCommitmentSchedule based on commitment
        GiftCommitmentSchedule schedule = new GiftCommitmentSchedule(
            Commitment__c = commitment.Id,
            NextPaymentDate__c = Date.today().addMonths(1) // Adjust as needed
        );
        insert schedule;
    }

    private void createGiftTribute(StripeResponse data, GiftTransaction giftTransaction) {
        // Extract honoree information and create a GiftTribute
        GiftTribute tribute = new GiftTribute(
            HonoreeName__c = data.data.objectz.metadata.honoree.HonoreeName,
            GiftTransaction__c = giftTransaction.Id,
            TributeType__c = data.data.objectz.metadata.honoree.tributeType
        );
        insert tribute;
    }
}
