@isTest
private class DonationSelectionControllerTest {

    @isTest
    private static void getDonationAmountsTest() {
        List<Donation_Amount__mdt> data = DonationSelectionController.getDonationAmounts();
        System.assert(data.size() > 0, 'No metadata records returned.');
    }

    @isTest
    private static void getSettingsTest() {
        Donation_Component__c data = DonationSelectionController.getSettings();
        System.assert(data != null, 'Donation component custom settings not returned.');
    }

    @isTest
    private static void getProcessingFeeTest() {
        Processing_Fee__c data = DonationSelectionController.getProcessingFee();
        System.assert(data != null, 'Processing fee custom settings not returned.');
    }

}