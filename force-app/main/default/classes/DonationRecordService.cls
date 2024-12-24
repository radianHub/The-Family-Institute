public without sharing class DonationRecordService {
	/**
	 * Creates a one-time gift transaction if applicable.
	 *
	 * @param accId      The Account Id record associated with the gift.
	 * @param stripeResponse The parsed Stripe response containing donation metadata.
	 * @param honoree      Honoree details if the gift is in honor of someone.
	 * @throws DonationProcessingException if any error occurs during record creation.
	 */
	public void createOneTimeGift(
		Id accId,
		Id personId,
		StripeResponse stripeResponse,
		StripeResponse.cls_honoree honoree,
		StripeResponse.cls_employer match,
		String giftType
	) {
		// Validate ids
		Id campaignId = validateId(stripeResponse.data.objectz.metadata.campaignId);
		Id oscId = validateId(stripeResponse.data.objectz.metadata.oscId);

		// Get campaign record using Outreach Source Code (ID provided in Stripe metadata)
		if (!String.isBlank(oscId)) {
			Id tempId = [SELECT CampaignId FROM OutreachSourceCode WHERE id = :oscId].CampaignId;
			if (tempId == null) {
				throw new DonationProcessingException('No Campaign associated with this Outreach Source Code');
			}
			campaignId = tempId;
		}

		Id gdId;
		try {
			if (campaignId != null) {
				gdId = [
					SELECT GiftDesignationId
					FROM GiftDefaultDesignation
					WHERE ParentRecordId = :campaignId AND GiftDesignation.isDefault = TRUE
					LIMIT 1
				]
				.GiftDesignationId;
			} else {
				gdId = [
					SELECT Id
					FROM GiftDesignation
					WHERE isDefault = TRUE
					LIMIT 1
				]
				.Id;
			}
		} catch (Exception ex) {
			System.debug('No default gift designation');
		}

		// Get donor information (person account)
		Account donor;
		if (accId == null) {
			donor = [SELECT Id, Name FROM Account WHERE Id = :personId];
		} else {
			donor = [SELECT Id, Name FROM Account WHERE Id = :accId];
		}

		Decimal giftAmt = Decimal.valueOf(stripeResponse.data.objectz.amount_total) / 100;

		// Create Matching Gift Transaction (if applicable)
		Id matchGiftId;
		if (match != null && match.isMatch) {
			AccountService accService = new AccountService();
			Id matchId = accService.getOrCreateOrgAccount(stripeResponse.data.objectz.customer_details, match);

			Account acc = [SELECT Id, Name FROM Account WHERE Id = :matchId];

			matchGiftId = StripeIntegrationHelper.dbInsert(
				new GiftTransaction(
					Name = acc.Name +
						' - ' +
						StripeIntegrationHelper.getAmountWithCents(giftAmt) +
						' - ' +
						String.valueOf(Date.today()),
					DonorId = matchId,
					GiftType = 'Organizational',
					CampaignId = campaignId,
					OutreachSourceCodeId = oscId,
					TransactionDate = Date.today(),
					Status = 'Unpaid',
					OriginalAmount = giftAmt,
					PaymentMethod = 'Unknown'
				)
			);
		}

		// Create GiftTransaction record
		Id gtId = StripeIntegrationHelper.dbInsert(
			new GiftTransaction(
				Name = donor.Name +
					' - ' +
					StripeIntegrationHelper.getAmountWithCents(giftAmt) +
					' - ' +
					String.valueOf(Date.today()),
				DonorId = donor.Id,
				GiftType = giftType,
				CampaignId = campaignId,
				OutreachSourceCodeId = oscId,
				TransactionDate = Date.today(),
				Status = 'Paid',
				OriginalAmount = giftAmt,
				PaymentMethod = 'Stripe',
				stripeId__c = stripeResponse.data.objectz.id,
				Anonymous_Donor__c = Boolean.valueOf(stripeResponse.data.objectz.metadata.anonymous),
				MatchingEmployerTransactionId = matchGiftId
			),
			GiftTransaction.Fields.stripeId__c
		);

		// Create Gift Designation record
		if (gdId != null) {
			StripeIntegrationHelper.dbInsert(
				new GiftTransactionDesignation(
					GiftTransactionId = gtId,
					GiftDesignationId = gdId,
					Percent = 100,
					Amount = giftAmt
				)
			);
		}

		// Create Gift Soft Credit and Gift Tribute (if applicable)
		try {
			if (honoree != null && honoree.isHonor) {
				// AccountService accService = new AccountService();
				// Id honoreeId = accService.getOrCreateHonoree(honoree);

				StripeIntegrationHelper.dbInsert(
					new List<SObject>{
						new GiftTribute(
							TributeType = honoree.honorType,
							GiftTransactionId = gtId,
							HonoreeName = honoree.honoreeInfo.FirstName + ' ' + honoree.honoreeInfo.LastName
						)
					}
				);
			}
		} catch (Exception ex) {
			throw new DonationProcessingException('Error processing honoree records. ' + ex.getMessage());
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
	// public void createRecurringGift(
	// 	Contact contact,
	// 	StripeResponse stripeResponse,
	// 	StripeResponse.cls_recurrence recurrence,
	// 	StripeResponse.cls_honoree honoree
	// ) {
	// 	try {
	// 		String giftType = stripeResponse.data.objectz.metadata.giftType == 'Organization'
	// 			? 'Organization'
	// 			: 'Individual';
	// 		String campaignId = validateCampaignId(stripeResponse.data.objectz.metadata.campaignId);

	// 		// Use current time for consistent timestamp across records
	// 		Datetime currentTime = Datetime.now();

	// 		// Create GiftTransaction record
	// 		GiftTransaction giftTransaction = new GiftTransaction(
	// 			OriginalAmount = Decimal.valueOf(stripeResponse.data.objectz.amount_total) / 100,
	// 			DonorId = contact.AccountId,
	// 			CampaignId = campaignId,
	// 			GiftType = giftType,
	// 			// Anonymous_Donor__c = stripeResponse.data.objectz.metadata.anonymous == 'true',
	// 			Name = contact.Name + ' - Recurring Donation - ' + currentTime,
	// 			PaymentMethod = 'Credit Card'
	// 		);
	// 		insert giftTransaction;

	// 		// Create GiftCommitment record
	// 		GiftCommitment commitment = new GiftCommitment(
	// 			// Amount__c = giftTransaction.OriginalAmount,
	// 			// Interval__c = recurrence.interval,
	// 			// Start_Date__c = Date.today(),
	// 			// Interval_Count__c = recurrence.intervalCount,
	// 			Name = contact.Name + ' - Recurring Donation - ' + currentTime,
	// 			DonorId = contact.AccountId
	// 		);
	// 		insert commitment;

	// 		// Create GiftCommitmentSchedule record
	// 		GiftCommitmentSchedule schedule = new GiftCommitmentSchedule(
	// 			// Due_Date__c = Date.today().addMonths(recurrence.intervalCount),
	// 			GiftCommitmentId = commitment.Id,
	// 			TransactionAmount = giftTransaction.OriginalAmount,
	// 			StartDate = Date.today()
	// 		);
	// 		insert schedule;

	// 		// Create GiftTribute record if honoree information is provided
	// 		if (honoree != null && honoree.hasHonor) {
	// 			GiftTribute tribute = new GiftTribute(
	// 				HonoreeName = honoree.FirstName + ' ' + honoree.LastName,
	// 				TributeType = honoree.honorType,
	// 				GiftCommitmentId = commitment.Id
	// 			);
	// 			insert tribute;
	// 		}
	// 	} catch (DmlException e) {
	// 		throw new DonationProcessingException(
	// 			'Error inserting GiftTransaction, GiftCommitment, GiftCommitmentSchedule, or GiftTribute record in createRecurringGift',
	// 			e
	// 		);
	// 	} catch (Exception e) {
	// 		throw new DonationProcessingException('An unexpected error occurred in createRecurringGift', e);
	// 	}
	// }

	/**
	 * Validates the ID by checking its format and returns null if invalid.
	 *
	 * @param id The ID to validate.
	 * @return The valid ID, or null if invalid.
	 */
	private String validateId(String id) {
		if (String.isBlank(id) || !Pattern.matches('[a-zA-Z0-9]{15,18}', id)) {
			return null; // Invalid or empty id
		}
		return id;
	}
}
