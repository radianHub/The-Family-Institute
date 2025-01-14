/**
 * @Class Name     : DonationRecordService
 * @Class Purpose  : Handles database logic for all objects related to donations.
 * @Author         : Zachary Csotya
 * @Developed On   : 01/10/2025
 * @Last Modified  : 01/10/2025
 **/
public without sharing class DonationRecordService {
	/**
	 * @description Creates a one-time gift transaction and associated records.
	 * @author Zachary  Csotya| 12/30/2024
	 * @param Id accId
	 * @param Id personId
	 * @param StripeResponse stripeResponse
	 * @param StripeResponse.cls_honoree honoree
	 * @param StripeResponse.cls_employer match
	 * @param String giftType
	 **/
	public void createOneTimeGift(
		Id accId,
		Id personId,
		StripeResponse stripeResponse,
		StripeResponse.cls_honoree honoree,
		StripeResponse.cls_employer match,
		String giftType
	) {
		// * Validate ids
		Id campaignId = validateId(stripeResponse.data.objectz.metadata.campaignId);
		Id oscId = validateId(stripeResponse.data.objectz.metadata.oscId);

		// * Get campaign record using Outreach Source Code (ID provided in Stripe metadata)
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

		// * Get donor information (person account)
		Account donor;
		if (accId == null) {
			donor = [SELECT Id, Name FROM Account WHERE Id = :personId];
		} else {
			donor = [SELECT Id, Name FROM Account WHERE Id = :accId];
		}

		Decimal giftAmt = Decimal.valueOf(stripeResponse.data.objectz.amount_total) / 100;

		// * Create GiftTransaction record
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
				EmployerMatch__c = match.isMatch,
				EmployerName__c = match.isMatch ? match.employerInfo.employerName : null
			),
			GiftTransaction.Fields.stripeId__c
		);

		// * Create Gift Designation record
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

		// * Create Gift Tribute (if applicable)
		try {
			if (honoree.isHonor) {
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
	 * @description Creates a recurring gift transaction and associated records.
	 * @author Zachary  Csotya| 12/30/2024
	 * @param Id accId
	 * @param Id personId
	 * @param StripeResponse stripeResponse
	 * @param StripeResponse.cls_recurrence recurrence
	 * @param StripeResponse.cls_honoree honoree
	 * @param StripeResponse.cls_employer match
	 * @param String giftType
	 **/
	public void createRecurringGift(
		Id accId,
		Id personId,
		StripeResponse stripeResponse,
		StripeResponse.cls_recurrence recurrence,
		StripeResponse.cls_honoree honoree,
		StripeResponse.cls_employer match,
		String giftType
	) {
		try {
			// * Validate ids
			Id campaignId = validateId(stripeResponse.data.objectz.metadata.campaignId);
			Id oscId = validateId(stripeResponse.data.objectz.metadata.oscId);

			// * Get campaign record using Outreach Source Code (ID provided in Stripe metadata)
			if (!String.isBlank(oscId)) {
				Id tempId = [SELECT CampaignId FROM OutreachSourceCode WHERE id = :oscId].CampaignId;
				if (tempId == null) {
					throw new DonationProcessingException('No Campaign associated with this Outreach Source Code');
				}
				campaignId = tempId;
			}

			// * Get default gift designation
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

			// * Get donor information (person account)
			Account donor;
			if (accId == null) {
				donor = [SELECT Id, Name FROM Account WHERE Id = :personId];
			} else {
				donor = [SELECT Id, Name FROM Account WHERE Id = :accId];
			}

			// * Convert gift amount from pennies to dollars
			Decimal giftAmt = Decimal.valueOf(stripeResponse.data.objectz.amount_total) / 100;

			// * Match Stripe interval to Salesforce interval
			String interval;
			switch on recurrence.interval {
				when 'week' {
					interval = 'Weekly';
				}
				when 'month' {
					interval = 'Monthly';
				}
				when 'year' {
					interval = 'Yearly';
				}
				when else {
					interval = 'Custom';
				}
			}

			// * Create GiftCommitment record
			GiftCommitment commitment = new GiftCommitment(
				Name = donor.Name + ' - ' + StripeIntegrationHelper.getAmountWithCents(giftAmt) + ' - ' + interval,
				DonorId = donor.Id,
				CampaignId = campaignId,
				Status = 'Active',
				ScheduleType = 'Recurring',
				EffectiveStartDate = Date.today(),
				FormalCommitmentType = 'Written',
				StripeSubscriptionId__c = stripeResponse.data.objectz.subscription
			);
			insert commitment;

			// * Create GiftCommitmentSchedule record
			GiftCommitmentSchedule schedule = new GiftCommitmentSchedule(
				CampaignId = campaignId,
				StartDate = Date.today(),
				TransactionPeriod = interval,
				TransactionDay = Date.today().day() == 31 ? 'LastDay' : String.valueOf(Date.today().day()),
				OutreachSourceCodeId = oscId,
				GiftCommitmentId = commitment.Id,
				TransactionAmount = giftAmt,
				TransactionInterval = recurrence.intervalCount,
				PaymentMethod = 'Stripe'
			);
			insert schedule;

			commitment.CurrentGiftCmtScheduleId = schedule.Id;
			update commitment;

			// * Create GiftDefaultDesignation record
			GiftDefaultDesignation defaultDesignation = new GiftDefaultDesignation(
				ParentRecordId = commitment.Id,
				GiftDesignationId = gdId,
				AllocatedPercentage = 100
			);
			insert defaultDesignation;

			// * Create GiftTransaction record
			GiftTransaction giftTransaction = new GiftTransaction(
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
				TransactionDueDate = Date.today(),
				Status = 'Paid',
				OriginalAmount = giftAmt,
				PaymentMethod = 'Stripe',
				stripeId__c = stripeResponse.data.objectz.invoice,
				Anonymous_Donor__c = Boolean.valueOf(stripeResponse.data.objectz.metadata.anonymous),
				GiftCommitmentId = commitment.Id,
				GiftCommitmentScheduleId = schedule.Id
			);
			insert giftTransaction;

			// * Create GiftTribute record if honoree information is provided
			if (honoree.isHonor) {
				StripeIntegrationHelper.dbInsert(
					new List<SObject>{
						new GiftTribute(
							TributeType = honoree.honorType,
							GiftTransactionId = giftTransaction.Id,
							GiftCommitmentId = commitment.Id,
							HonoreeName = honoree.honoreeInfo.FirstName + ' ' + honoree.honoreeInfo.LastName
						)
					}
				);
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
	 * @description Updates Gift Transactions with Stripe Invoice ID from Stripe Invoice Response.
	 * @author Zachary  Csotya| 12/30/2024
	 * @param StripeInvoiceResponse stripeResponse
	 **/
	public void handleIncomingInvoice(StripeInvoiceResponse stripeResponse) {
		String subscriptionId = stripeResponse.data.objectz.subscription;
		String invoiceId = stripeResponse.data.objectz.id;

		// * Get Gift Commitment record, exist if none, exit
		GiftCommitment commitment;
		try {
			commitment = [
				SELECT Id, Name
				FROM GiftCommitment
				WHERE StripeSubscriptionId__c = :subscriptionId
			];
		} catch (Exception ex) {
			throw new DonationProcessingException('No Gift Commitment found for Subscription ID: ' + subscriptionId);
		}

		// * Get Gift Transactions, if none exist, exit
		List<GiftTransaction> transactions = [
			SELECT Id, stripeId__c
			FROM GiftTransaction
			WHERE stripeId__c = NULL AND GiftCommitmentId = :commitment.Id
		];
		if (transactions.isEmpty()) {
			throw new DonationProcessingException('No Gift Transactions found for Gift Commitment: ' + commitment.Name);
		}

		// * Update Gift Transactions with Stripe Invoice ID
		Set<GiftTransaction> transactionSet = new Set<GiftTransaction>();
		for (GiftTransaction trans : transactions) {
			transactionSet.add(new GiftTransaction(Id = trans.Id, stripeId__c = invoiceId));
		}

		update new List<GiftTransaction>(transactionSet);
	}

	/**
	 * @description Finds and ends a Gift Commitment and Gift Commitment Schedule.
	 * @author Zachary Csotya | 01/10/2025
	 * @param StripeCancellationResponse response
	 **/
	public void endGiftCommitment(StripeCancellationResponse response) {
		String subscriptionId = response.data.objectz.id;
		Date endDate = DateTime.newInstance((Long) response.data.objectz.ended_at * 1000).date();

		GiftCommitment commitment = [
			SELECT Id, StripeSubscriptionId__c, CurrentGiftCmtScheduleId
			FROM GiftCommitment
			WHERE StripeSubscriptionId__c = :subscriptionId
		];

		Set<SObject> recordsToUpdate = new Set<SObject>{
			new GiftCommitment(Id = commitment.Id, Status = 'Closed', ExpectedEndDate = endDate),
			new GiftCommitmentSchedule(Id = commitment.CurrentGiftCmtScheduleId, EndDate = endDate)
		};

		update new List<SObject>(recordsToUpdate);
	}

	/**
	 * @description Validates the ID by checking its format and returns null if invalid.
	 * @author Zachary  Csotya| 12/30/2024
	 * @param String id
	 * @return String
	 **/
	private String validateId(String id) {
		if (String.isBlank(id) || !Pattern.matches('[a-zA-Z0-9]{15,18}', id)) {
			return null; // * Invalid or empty id
		}
		return id;
	}
}
