/**
 * @Class Name     : DonationRecordService
 * @Class Purpose  : Handles database logic for all objects related to donations.
 * @Author         : Zachary Csotya
 * @Developed On   : 01/10/2025
 * @Last Modified  : 03/21/2025
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
	 * @description Creates one time gift transactions for a one-time ticket purchase.
	 * @author Zachary Csotya | 03/12/2025
	 * @param Id personId
	 * @param String campaignId
	 * @param String stripeCheckoutId
	 * @param String recordType
	 **/
	@future(callout=true)
	public static void createOneTimeGift(Id personId, String campaignId, String stripeCheckoutId, String recordType) {
		Id gdId;
		try {
			gdId = [
				SELECT GiftDesignationId
				FROM GiftDefaultDesignation
				WHERE ParentRecordId = :campaignId AND GiftDesignation.isDefault = TRUE
				LIMIT 1
			]
			.GiftDesignationId;
		} catch (Exception ex) {
			System.debug('No default gift designation');
		}

		// * Get donor information (person account)
		Account donor = [SELECT Id, Name FROM Account WHERE Id = :personId];

		// * Fetch line items and ticket quantities
		StripeIntegrationHelper.SessionLineItem lineItem = StripeIntegrationHelper.getSessionLineItems(
			stripeCheckoutId
		);

		// * Create gift transactions for each ticket purchased
		List<GiftTransaction> giftTransactionsToInsert = new List<GiftTransaction>();

		// Loop through each line item (only 1 expected)
		for (StripeIntegrationHelper.LineItemData li : lineItem.data) {
			// Loop over line items while quantity is less than i
			Integer i = 1;
			while (i <= li.quantity) {
				Decimal amt = (Decimal) li.price.unit_amount / 100;

				// Build gift transaction record
				giftTransactionsToInsert.add(
					new GiftTransaction(
						Name = donor.Name +
							' - ' +
							StripeIntegrationHelper.getAmountWithCents(amt) +
							' - ' +
							String.valueOf(Date.today()),
						DonorId = personId,
						GiftType = 'Individual',
						CampaignId = campaignId,
						TransactionDate = Date.today(),
						TransactionDueDate = Date.today(),
						Status = 'Paid',
						OriginalAmount = amt,
						PaymentMethod = 'Stripe',
						stripeId__c = stripeCheckoutId + '_' + String.valueOf(i),
						RecordTypeId = Schema.SObjectType.GiftTransaction.getRecordTypeInfosByDeveloperName()
							.get(recordType)
							.getRecordTypeId()
					)
				);
				i++;
			}
		}

		List<Id> giftTransactionIds = StripeIntegrationHelper.dbInsert(giftTransactionsToInsert);
		Map<Id, Decimal> giftAmountMap = new Map<Id, Decimal>();
		for (GiftTransaction giftTransaction : giftTransactionsToInsert) {
			giftAmountMap.put(giftTransaction.Id, giftTransaction.OriginalAmount);
		}

		List<GiftTransactionDesignation> giftTransactionDesignationsToInsert = new List<GiftTransactionDesignation>();
		for (Id giftTransactionId : giftTransactionIds) {
			giftTransactionDesignationsToInsert.add(
				new GiftTransactionDesignation(
					GiftTransactionId = giftTransactionId,
					GiftDesignationId = gdId,
					Percent = 100,
					Amount = giftAmountMap.get(giftTransactionId)
				)
			);
		}

		StripeIntegrationHelper.dbInsert(giftTransactionDesignationsToInsert);
	}

	public void createZeroDollarTicket(String personId, String campaignId, Integer ticketCount) {
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
			}
		} catch (Exception ex) {
			System.debug('No default gift designation');
		}

		// * Get person info
		Account donor = [SELECT Id, Name FROM Account WHERE Id = :personId];

		// * Create gift transactions for each ticketCount
		List<GiftTransaction> giftTransactionsToInsert = new List<GiftTransaction>();
		for (Integer i = 0; i < ticketCount; i++) {
			giftTransactionsToInsert.add(
				new GiftTransaction(
					Name = donor.Name + ' - $0.00 - ' + String.valueOf(Date.today()),
					DonorId = personId,
					CampaignId = campaignId,
					GiftType = 'Individual',
					TransactionDate = Date.today(),
					TransactionDueDate = Date.today(),
					Status = 'Paid',
					OriginalAmount = 0.01,
					Description = 'This transaction should be treated as a zero dollar registration. Gift transactions are required to have an amount great than $0.00 which is why the amount is $0.01.',
					PaymentMethod = 'Stripe',
					RecordTypeId = Schema.SObjectType.GiftTransaction.getRecordTypeInfosByDeveloperName()
						.get('Ticket')
						.getRecordTypeId()
				)
			);
		}

		List<Id> giftTransactionIds = StripeIntegrationHelper.dbInsert(giftTransactionsToInsert);

		// * Create default gift designation for each gift transaction created
		List<GiftTransactionDesignation> giftTransactionDesignationsToInsert = new List<GiftTransactionDesignation>();
		for (Id giftTransactionId : giftTransactionIds) {
			giftTransactionDesignationsToInsert.add(
				new GiftTransactionDesignation(
					GiftTransactionId = giftTransactionId,
					GiftDesignationId = gdId,
					Percent = 100,
					Amount = 0.01
				)
			);
		}

		StripeIntegrationHelper.dbInsert(giftTransactionDesignationsToInsert);
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
	 * @description Creates a payment plan for a ticket purchase.
	 * @author Zachary Csotya | 03/13/2025
	 * @param Id personId
	 * @param String campaignId
	 * @param String stripeCheckoutId
	 * @param String stripeSubscriptionId
	 * @param String stripeInvoiceId
	 * @param Integer paymentLength
	 * @param String recordType
	 **/
	public void createRecurringGift(
		Id personId,
		String campaignId,
		StripeResponse stripeResponse,
		Integer paymentLength,
		String recordType
	) {
		Id gdId;
		try {
			gdId = [
				SELECT GiftDesignationId
				FROM GiftDefaultDesignation
				WHERE ParentRecordId = :campaignId AND GiftDesignation.isDefault = TRUE
				LIMIT 1
			]
			.GiftDesignationId;
		} catch (Exception ex) {
			System.debug('No default gift designation');
		}

		// * Get donor information (person account)
		Account donor = [SELECT Id, Name FROM Account WHERE Id = :personId];

		// * Convert Amount from pennies to dollars
		Decimal total = (Decimal) stripeResponse.data.objectz.amount_total / 100;

		// * Create a new commitment
		GiftCommitment commitment = new GiftCommitment(
			Name = Donor.Name + ' - ' + StripeIntegrationHelper.getAmountWithCents(total) + ' - Monthly',
			DonorId = donor.Id,
			CampaignId = campaignId,
			Status = 'Active',
			ScheduleType = 'Recurring',
			EffectiveStartDate = Date.today(),
			FormalCommitmentType = 'Written',
			StripeSubscriptionId__c = stripeResponse.data.objectz.subscription
		);
		insert commitment;

		// * Create new commitment schedule
		GiftCommitmentSchedule schedule = new GiftCommitmentSchedule(
			CampaignId = campaignId,
			StartDate = Date.today(),
			TransactionPeriod = 'Monthly',
			TransactionDay = Date.today().day() == 31 ? 'LastDay' : String.valueOf(Date.today().day()),
			EndDate = Date.today().addMonths(paymentLength),
			GiftCommitmentId = commitment.Id,
			TransactionAmount = total,
			TransactionInterval = 1,
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

		// * Create a gift transaction (to be split by ticket when invoice response is received)
		GiftTransaction giftTransaction = new GiftTransaction(
			Name = donor.Name +
				' - ' +
				StripeIntegrationHelper.getAmountWithCents(total) +
				' - ' +
				String.valueOf(Date.today()),
			DonorId = donor.Id,
			GiftType = 'Individual',
			CampaignId = campaignId,
			TransactionDate = Date.today(),
			TransactionDueDate = Date.today(),
			Status = 'Pending',
			OriginalAmount = total,
			PaymentMethod = 'Stripe',
			RecordTypeId = Schema.SObjectType.GiftTransaction.getRecordTypeInfosByDeveloperName()
				.get(recordType)
				.getRecordTypeId(),
			GiftCommitmentId = commitment.Id,
			GiftCommitmentScheduleId = schedule.Id
		);
		insert giftTransaction;
	}

	/**
	 * @description Updates Gift Transactions with Stripe Invoice ID from Stripe Invoice Response.
	 * @author Zachary  Csotya| 12/30/2024
	 * @param StripeInvoiceResponse stripeResponse
	 **/
	public void handleIncomingInvoice(
		StripeInvoiceResponse stripeResponse,
		StripeInvoiceResponse.cls_subscription_details_metadata metadata
	) {
		String subscriptionId = stripeResponse.data.objectz.subscription;
		String invoiceId = stripeResponse.data.objectz.id;
		Boolean isTicket = metadata?.isTicket != null ? Boolean.valueOf(metadata.isTicket) : false;

		// * Get Gift Commitment record, exist if none, exit
		GiftCommitment commitment;
		try {
			commitment = [
				SELECT Id, Name, DonorId, Donor.Name, CampaignId, CurrentGiftCmtScheduleId
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
		if (isTicket) {
			Integer i = 1;
			Decimal unitAmt = (Decimal) stripeResponse.data.objectz.lines.data[0].price.unit_amount / 100;
			while (i <= stripeResponse.data.objectz.lines.data[0].quantity) {
				if (i == 1) {
					transactionSet.add(
						new GiftTransaction(
							Id = transactions[0].id,
							Name = commitment.Donor.Name +
								' - ' +
								StripeIntegrationHelper.getAmountWithCents(unitAmt) +
								' - ' +
								String.valueOf(Date.today()),
							Status = 'Paid',
							TransactionDueDate = Date.today(),
							TransactionDate = Date.today(),
							OriginalAmount = unitAmt,
							stripeId__c = invoiceId + '_' + i,
							RecordTypeId = Schema.SObjectType.GiftTransaction.getRecordTypeInfosByDeveloperName()
								.get('Ticket')
								.getRecordTypeId()
						)
					);
				} else {
					transactionSet.add(
						new GiftTransaction(
							DonorId = commitment.DonorId,
							GiftCommitmentId = commitment.Id,
							GiftCommitmentScheduleId = commitment.CurrentGiftCmtScheduleId,
							CampaignId = commitment.CampaignId,
							Name = commitment.Donor.Name +
								' - ' +
								StripeIntegrationHelper.getAmountWithCents(unitAmt) +
								' - ' +
								String.valueOf(Date.today()),
							PaymentMethod = 'Stripe',
							Status = 'Paid',
							TransactionDueDate = Date.today(),
							TransactionDate = Date.today(),
							OriginalAmount = unitAmt,
							stripeId__c = invoiceId + '_' + i,
							RecordTypeId = Schema.SObjectType.GiftTransaction.getRecordTypeInfosByDeveloperName()
								.get('Ticket')
								.getRecordTypeId()
						)
					);
				}
				i++;
			}
		} else {
			for (GiftTransaction trans : transactions) {
				transactionSet.add(new GiftTransaction(Id = trans.Id, Status = 'Paid', stripeId__c = invoiceId));
			}
		}

		upsert new List<GiftTransaction>(transactionSet);
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
