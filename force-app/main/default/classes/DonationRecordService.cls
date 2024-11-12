public without sharing class DonationRecordService {
	/**
	 * Creates a one-time gift transaction and a gift tribute if applicable.
	 *
	 * @param contact      The Contact record associated with the gift.
	 * @param stripeResponse The parsed Stripe response containing donation metadata.
	 * @param honoree      Honoree details if the gift is in honor of someone.
	 * @throws DonationProcessingException if any error occurs during record creation.
	 */
	public void createOneTimeGift(Contact contact, StripeResponse stripeResponse, StripeResponse.cls_honoree honoree) {
		try {
			// Determine gift type and validate campaign ID
			String giftType = stripeResponse.data.objectz.metadata.giftType == 'Organization'
				? 'Organization'
				: 'Individual';
			String campaignId = validateCampaignId(stripeResponse.data.objectz.metadata.campaignId);

			// Use current time for consistent timestamp across records
			Datetime currentTime = Datetime.now();

			// Create GiftTransaction record
			GiftTransaction giftTransaction = new GiftTransaction(
				OriginalAmount = Decimal.valueOf(stripeResponse.data.objectz.amount_total) / 100,
				DonorId = contact.AccountId,
				CampaignId = campaignId,
				GiftType = giftType,
				Anonymous_Donor__c = stripeResponse.data.objectz.metadata.anonymous == 'true',
				Name = contact.Name + ' - One-Time Donation - ' + currentTime,
				PaymentMethod = 'Credit Card' // Assuming 'Credit Card'; adjust as needed
			);
			insert giftTransaction;

			// Create GiftTribute record if honoree information is provided
			if (honoree != null && honoree.hasHonor) {
				GiftTribute tribute = new GiftTribute(
					HonoreeName = honoree.FirstName + ' ' + honoree.LastName,
					TributeType = honoree.honorType,
					GiftTransactionId = giftTransaction.Id
				);
				insert tribute;
			}
		} catch (DmlException e) {
			throw new DonationProcessingException(
				'Error inserting GiftTransaction or GiftTribute record in createOneTimeGift',
				e
			);
		} catch (Exception e) {
			throw new DonationProcessingException('An unexpected error occurred in createOneTimeGift', e);
		}
	}

	/**
	 * Creates a recurring gift transaction, including GiftCommitment and GiftCommitmentSchedule records,
	 * and a gift tribute if applicable.
	 *
	 * @param contact      The Contact record associated with the gift.
	 * @param stripeResponse The parsed Stripe response containing donation metadata.
	 * @param recurrence   Recurrence details for the gift.
	 * @param honoree      Honoree details if the gift is in honor of someone.
	 * @throws DonationProcessingException if any error occurs during record creation.
	 */
	public void createRecurringGift(
		Contact contact,
		StripeResponse stripeResponse,
		StripeResponse.cls_recurrence recurrence,
		StripeResponse.cls_honoree honoree
	) {
		try {
			String giftType = stripeResponse.data.objectz.metadata.giftType == 'Organization'
				? 'Organization'
				: 'Individual';
			String campaignId = validateCampaignId(stripeResponse.data.objectz.metadata.campaignId);

			// Use current time for consistent timestamp across records
			Datetime currentTime = Datetime.now();

			// Create GiftTransaction record
			GiftTransaction giftTransaction = new GiftTransaction(
				OriginalAmount = Decimal.valueOf(stripeResponse.data.objectz.amount_total) / 100,
				DonorId = contact.AccountId,
				CampaignId = campaignId,
				GiftType = giftType,
				Anonymous_Donor__c = stripeResponse.data.objectz.metadata.anonymous == 'true',
				Name = contact.Name + ' - Recurring Donation - ' + currentTime,
				PaymentMethod = 'Credit Card'
			);
			insert giftTransaction;

			// Create GiftCommitment record
			GiftCommitment commitment = new GiftCommitment(
				Amount__c = giftTransaction.OriginalAmount,
				Interval__c = recurrence.interval,
				Start_Date__c = Date.today(),
				Interval_Count__c = recurrence.intervalCount,
				Name = contact.Name + ' - Recurring Donation - ' + currentTime,
				DonorId = contact.AccountId
			);
			insert commitment;

			// Create GiftCommitmentSchedule record
			GiftCommitmentSchedule schedule = new GiftCommitmentSchedule(
				Due_Date__c = Date.today().addMonths(recurrence.intervalCount),
				GiftCommitmentId = commitment.Id,
				TransactionAmount = giftTransaction.OriginalAmount,
				StartDate = Date.today()
			);
			insert schedule;

			// Create GiftTribute record if honoree information is provided
			if (honoree != null && honoree.hasHonor) {
				GiftTribute tribute = new GiftTribute(
					HonoreeName = honoree.FirstName + ' ' + honoree.LastName,
					TributeType = honoree.honorType,
					GiftCommitmentId = commitment.Id
				);
				insert tribute;
			}
		} catch (DmlException e) {
			throw new DonationProcessingException(
				'Error inserting GiftTransaction, GiftCommitment, GiftCommitmentSchedule, or GiftTribute record in createRecurringGift',
				e
			);
		} catch (Exception e) {
			throw new DonationProcessingException('An unexpected error occurred in createRecurringGift', e);
		}
	}

	/**
	 * Validates the campaign ID by checking its format and returns null if invalid.
	 *
	 * @param campaignId The campaign ID to validate.
	 * @return The valid campaign ID, or null if invalid.
	 */
	private String validateCampaignId(String campaignId) {
		if (String.isBlank(campaignId) || !Pattern.matches('[a-zA-Z0-9]{15,18}', campaignId)) {
			return null; // Invalid or empty campaign ID
		}
		return campaignId;
	}
}
