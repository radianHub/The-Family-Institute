public with sharing class DonationSelectionController {

    @AuraEnabled(cacheable=true)
    public static List<Donation_Amount__mdt> getDonationAmounts() {
        return [
            SELECT 
                DeveloperName,
                Auto_Calculate__c,
                Percentage_to_Auto_Calculate__c,
                Starting_Amount__c,
                Giving_Amount_1__c,
                Giving_Amount_2__c,
                Giving_Amount_3__c,
                Giving_Amount_4__c,
                Giving_Amount_5__c,
                Giving_Amount_6__c
            FROM Donation_Amount__mdt
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Donation_Component__c getSettings(){
        return Donation_Component__c.getOrgDefaults();
    }

    @AuraEnabled(cacheable=true)
    public static Processing_Fee__c getProcessingFee(){
        return Processing_Fee__c.getOrgDefaults();
    }
}