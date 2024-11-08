@RestResource(UrlMapping='/stripe-checkout')
global without sharing class StripeCallbackResource {
	@HttpPost
	global static void doPost() {
		String d = RestContext.request.requestBody.toString();

		// * REFORMAT JSON
		String formattedJSONString = d.replace('object', 'objectz');

		// * PARSE JSON RESPONSE
		StripeResponse sRes = (StripeResponse) JSON.deserialize(formattedJSONString, StripeResponse.class);

		// * PARSE HONOREE JSON
		StripeResponse.cls_honoree honoree = new StripeResponse.cls_honoree().parse(sRes.data.objectz.metadata.honoree);

		// * PARSE RECURRENCE JSON
		StripeResponse.cls_recurrence recurrence = new StripeResponse.cls_recurrence()
			.parse(sRes.data.objectz.metadata.recurrence);

		System.debug(formattedJSONString);
		System.debug(honoree);
		System.debug(recurrence);
		System.debug(sRes.data.objectz.metadata.campaignId);
		System.debug(sRes.data.objectz.subscription);

		switch on recurrence.interval {
			when 'week' {
				recurrence.interval = 'Weekly';
			}
			when 'month' {
				recurrence.interval = 'Monthly';
			}
			when 'year' {
				recurrence.interval = 'Yearly';
			}
			when else {
				recurrence.interval = 'Once';
			}
		}

		sRes.data.objectz.metadata.campaignId = sRes.data.objectz.metadata.campaignId == 'undefined'
			? null
			: sRes.data.objectz.metadata.campaignId;

		// * SPLIT CUSTOMER NAME -> FIRST NAME / LAST NAME
		List<String> name = sRes.data.objectz.customer_details.name.split(' ');
		String lName = name.size() > 2 ? name.get(name.size() - 1) : name.get(1);
		String fName;
		if (name.size() > 2) {
			name.remove(name.size() - 1);
			fName = String.join(name, ' ');
		} else {
			fName = name.get(0);
		}

		// * CHECK FOR EXISTING CONTACT AND CREATE NEW IF NON EXIST
		List<Contact> conList = [SELECT Id FROM Contact WHERE Email = :sRes.data.objectz.customer_details.email];
		Contact con;
		if (conList.size() > 0) {
			con = conList[0];
		} else {
			con = new Contact(
				RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Standard']
				.Id,
				FirstName = fName,
				LastName = lName,
				Email = sRes.data.objectz.customer_details.email,
				Phone = sRes.data.objectz.customer_details.phone.removeStart('+1'),
				MailingStreet = sRes.data.objectz.customer_details.address.line2 == null
					? sRes.data.objectz.customer_details.address.line1
					: sRes.data.objectz.customer_details.address.line1 +
					  ' ' +
					  sRes.data.objectz.customer_details.address.line2,
				MailingCity = sRes.data.objectz.customer_details.address.city,
				MailingState = sRes.data.objectz.customer_details.address.state,
				MailingPostalCode = sRes.data.objectz.customer_details.address.postal_code,
				MailingCountry = sRes.data.objectz.customer_details.address.country
			);
			insert con;
		}

		// * IF CAMPAIGN ID IS INCLUDED CREATE CAMPAIGN MEMBER RECORD
		if (sRes.data.objectz.metadata.campaignId != null) {
			List<CampaignMember> memList = [
				SELECT Id
				FROM CampaignMember
				WHERE CampaignId = :sRes.data.objectz.metadata.campaignId AND ContactId = :con.Id
			];
			if (memList.size() == 0) {
				CampaignMember mem = new CampaignMember(
					CampaignId = sRes.data.objectz.metadata.campaignId,
					ContactId = con.Id,
					Status = 'Donated'
				);
				insert mem;
			}
		}

		// * CHECK FOR DONATION HONOREE AND CREATE NEW CONTACT
		// Contact hCon;
		// if (honoree?.hasHonor != null && honoree?.hasHonor) {
		// hCon = new Contact(
		// 	RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Standard']
		// 	.Id,
		// 	FirstName = honoree.FirstName,
		// 	LastName = honoree.LastName,
		// 	Date_Matching__c = Date.today().format(),
		// 	Email = honoree.Email,
		// 	Phone = honoree.Phone,
		// 	MailingStreet = honoree.Street,
		// 	MailingCity = honoree.City,
		// 	MailingState = honoree.State,
		// 	MailingPostalCode = honoree.Zip
		// );
		// insert hCon;
		// }

		// * PAYMENT MODE
		if (sRes.data.objectz.mode == 'payment') {
			// * CREATE NEW OPPORTUNITY
			Opportunity opp = new Opportunity(
				Name = sRes.data.objectz.customer_details.name +
					' - ' +
					DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000).date().format(),
				StageName = 'Pledged',
				CloseDate = DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000).date(),
				Amount = Decimal.valueOf(sRes.data.objectz.amount_total) / 100,
				RecordTypeId = (Decimal.valueOf(sRes.data.objectz.amount_total) / 100) >= 1000
					? [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'MajorGift'].Id
					: [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'Donation'].Id,
				AccountId = [SELECT AccountId FROM Contact WHERE Id = :con.Id]
				.AccountId,
				npsp__Primary_Contact__c = con.Id,
				CampaignId = sRes.data.objectz.metadata.campaignId,
				Stripe_Transaction_Id__c = sRes.data.objectz.id,
				isPrivate = sRes.data.objectz.metadata.anonymous == 'true' ? true : false
			);

			if (honoree?.hasHonor != null && honoree?.hasHonor) {
				// opp.npsp__Honoree_Contact__c = hCon.Id;
				opp.Description = honoree.HonoreeDescription;
				opp.npsp__Tribute_Type__c = honoree.honorType.capitalize();
			}

			insert opp;

			// * MARK PAYMENT PAID
			npe01__OppPayment__c pmnt = [
				SELECT Id, npe01__Payment_Method__c, npe01__Paid__c, npe01__Payment_Date__c
				FROM npe01__OppPayment__c
				WHERE npe01__Opportunity__c = :opp.Id AND npe01__Paid__c = FALSE
			];

			pmnt.npe01__Payment_Method__c = sRes.data.objectz.payment_method_types[0].capitalize();
			pmnt.npe01__Paid__c = sRes.data.objectz.payment_status == 'paid' ? true : false;
			pmnt.npe01__Payment_Date__c = DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000).date();
			update pmnt;

			// * SUBSCRIPTION MODE
		} else if (sRes.data.objectz.mode == 'subscription') {
			// * LOOK FOR EXISTING RECURRING DONATION
			List<npe03__Recurring_Donation__c> recurList = [
				SELECT Id
				FROM npe03__Recurring_Donation__c
				WHERE Stripe_Subscription_Id__c = :sRes.data.objectz.subscription
			];

			// * CREATE NEW RECURRING DONATION IF NON EXIST
			npe03__Recurring_Donation__c recur;
			if (recurList.size() == 0) {
				recur = new npe03__Recurring_Donation__c(
					npe03__Contact__c = con.Id,
					// npe03__Organization__c = [SELECT AccountId FROM Contact WHERE Id = :con.Id].AccountId,
					Name = fName +
						' ' +
						lName +
						'$' +
						(Decimal.valueOf(sRes.data.objectz.amount_total) / 100).toString() +
						' - Recurring',
					npe03__Date_Established__c = DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000).date(),
					npsp__RecurringType__c = 'Open',
					npe03__Amount__c = Decimal.valueOf(sRes.data.objectz.amount_total) / 100,
					npe03__Installment_Period__c = recurrence.interval,
					npsp__InstallmentFrequency__c = recurrence.intervalCount,
					npsp__PaymentMethod__c = sRes.data.objectz.payment_method_types[0].capitalize(),
					npsp__Day_of_Month__c = DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000)
							.date()
							.day() == 31
						? 'Last_Day'
						: DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000).date().day().toString(),
					npe03__Next_Payment_Date__c = DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000)
						.date()
						.addMonths(1),
					npsp__StartDate__c = DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000).date(),
					npe03__Recurring_Donation_Campaign__c = sRes.data.objectz.metadata.campaignId,
					Stripe_Subscription_Id__c = sRes.data.objectz.subscription
				);
				insert recur;

				// * QUERY FOR NEW OPP TO ASSIGN TRANSACTION ID
				Opportunity opp = [
					SELECT Id, Stripe_Transaction_Id__c, npsp__Honoree_Contact__c, RecordTypeId, isPrivate
					FROM Opportunity
					WHERE npe03__Recurring_Donation__c = :recur.Id AND Stripe_Transaction_Id__c = NULL
				];
				opp.isPrivate = sRes.data.objectz.metadata.anonymous == 'true' ? true : false;
				opp.Stripe_Transaction_Id__c = sRes.data.objectz.invoice;
				opp.RecordTypeId = (Decimal.valueOf(sRes.data.objectz.amount_total) / 100) >= 1000
					? [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'MajorGift'].Id
					: [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'Donation'].Id;
				if (honoree?.hasHonor != null && honoree?.hasHonor) {
					// opp.npsp__Honoree_Contact__c = hCon.Id;
					opp.Description = honoree.HonoreeDescription;
					opp.npsp__Tribute_Type__c = honoree.honorType.capitalize();
				}
				update opp;

				// * MARK PAYMENT PAID
				npe01__OppPayment__c pmnt = [
					SELECT Id, npe01__Payment_Method__c, npe01__Paid__c, npe01__Payment_Date__c
					FROM npe01__OppPayment__c
					WHERE npe01__Opportunity__c = :opp.Id AND npe01__Paid__c = FALSE
				];
				pmnt.npe01__Payment_Method__c = sRes.data.objectz.payment_method_types[0].capitalize();
				pmnt.npe01__Paid__c = sRes.data.objectz.payment_status == 'paid' ? true : false;
				pmnt.npe01__Payment_Date__c = DateTime.newInstance(((Long) sRes.data.objectz.created) * 1000).date();
				update pmnt;
			}
		}
	}
}
