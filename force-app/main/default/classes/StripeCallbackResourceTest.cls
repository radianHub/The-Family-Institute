@isTest
private class StripeCallbackResourceTest {
	static RestRequest req;
    static Campaign camp;
	static String recurringCheckout =
		'{' +
		'  "id": "evt_1PCQ5ACsC2AzqBfwqS8VZDta",' +
		'  "object": "event",' +
		'  "api_version": "2024-04-10",' +
		'  "created": 1714757980,' +
		'  "data": {' +
		'    "object": {' +
		'      "id": "cs_test_a1gS2ZHhyvBaayvBBerEQf4YbP0am3rAx7y63PFb3HkTYBaqAcstk3wQIl",' +
		'      "object": "checkout.session",' +
		'      "after_expiration": null,' +
		'      "allow_promotion_codes": null,' +
		'      "amount_subtotal": 7500,' +
		'      "amount_total": 7500,' +
		'      "automatic_tax": {' +
		'        "enabled": false,' +
		'        "liability": null,' +
		'        "status": null' +
		'      },' +
		'      "billing_address_collection": "required",' +
		'      "cancel_url": "https://peopleincorporated--dev.sandbox.lightning.force.com",' +
		'      "client_reference_id": null,' +
		'      "client_secret": null,' +
		'      "consent": null,' +
		'      "consent_collection": null,' +
		'      "created": 1714757972,' +
		'      "currency": "usd",' +
		'      "currency_conversion": null,' +
		'      "custom_fields": [' +
		'      ],' +
		'      "custom_text": {' +
		'        "after_submit": null,' +
		'        "shipping_address": null,' +
		'        "submit": null,' +
		'        "terms_of_service_acceptance": null' +
		'      },' +
		'      "customer": "cus_Q2V5bAWY4MnWds",' +
		'      "customer_creation": "always",' +
		'      "customer_details": {' +
		'        "address": {' +
		'          "city": "San Francisco",' +
		'          "country": "US",' +
		'          "line1": "123 Market Street",' +
		'          "line2": null,' +
		'          "postal_code": "94105",' +
		'          "state": "CA"' +
		'        },' +
		'        "email": "test@test.com",' +
		'        "name": "Jack Sparrow",' +
		'        "phone": "+11231231234",' +
		'        "tax_exempt": "none",' +
		'        "tax_ids": [' +
		'        ]' +
		'      },' +
		'      "customer_email": null,' +
		'      "expires_at": 1714844372,' +
		'      "invoice": "in_1PCQ56CsC2AzqBfweyhWVdJ",' +
		'      "invoice_creation": null,' +
		'      "livemode": false,' +
		'      "locale": null,' +
		'      "metadata": {' +
		'        "campaignId": "undefined",' +
		'        "recurrence": "{\\"isRecurring\\":true,\\"interval\\":\\"month\\",\\"intervalCount\\":3}",' +
		'        "honoree": "{\\"hasHonor\\":false}"' +
		'      },' +
		'      "mode": "subscription",' +
		'      "payment_intent": null,' +
		'      "payment_link": null,' +
		'      "payment_method_collection": "always",' +
		'      "payment_method_configuration_details": null,' +
		'      "payment_method_options": {' +
		'        "card": {' +
		'          "request_three_d_secure": "automatic"' +
		'        }' +
		'      },' +
		'      "payment_method_types": [' +
		'        "card"' +
		'      ],' +
		'      "payment_status": "paid",' +
		'      "phone_number_collection": {' +
		'        "enabled": true' +
		'      },' +
		'      "recovered_from": null,' +
		'      "saved_payment_method_options": {' +
		'        "allow_redisplay_filters": [' +
		'          "always"' +
		'        ],' +
		'        "payment_method_save": null' +
		'      },' +
		'      "setup_intent": null,' +
		'      "shipping_address_collection": null,' +
		'      "shipping_cost": null,' +
		'      "shipping_details": null,' +
		'      "shipping_options": [' +
		'      ],' +
		'      "status": "complete",' +
		'      "submit_type": null,' +
		'      "subscription": "sub_1PCQ56CsC2AzqBfwBDFiENa",' +
		'      "success_url": "https://peopleincorporated--dev.sandbox.lightning.force.com",' +
		'      "total_details": {' +
		'        "amount_discount": 0,' +
		'        "amount_shipping": 0,' +
		'        "amount_tax": 0' +
		'      },' +
		'      "ui_mode": "hosted",' +
		'      "url": null' +
		'    }' +
		'  },' +
		'  "livemode": false,' +
		'  "pending_webhooks": 1,' +
		'  "request": {' +
		'    "id": null,' +
		'    "idempotency_key": null' +
		'  },' +
		'  "type": "checkout.session.completed"' +
		'}';

	static String invoice =
		'{' +
		'  "id": "evt_1PCQhXCsC2AzqBfwRDJF392k",' +
		'  "object": "event",' +
		'  "api_version": "2024-04-10",' +
		'  "created": 1714760358,' +
		'  "data": {' +
		'    "object": {' +
		'      "id": "in_1PCQhFCsC2AzqBfwMcsai3Qa",' +
		'      "object": "invoice",' +
		'      "account_country": "US",' +
		'      "account_name": "Jack Sparrow",' +
		'      "account_tax_ids": null,' +
		'      "amount_due": 7500,' +
		'      "amount_paid": 7500,' +
		'      "amount_remaining": 0,' +
		'      "amount_shipping": 0,' +
		'      "application": null,' +
		'      "application_fee_amount": null,' +
		'      "attempt_count": 1,' +
		'      "attempted": true,' +
		'      "auto_advance": false,' +
		'      "automatic_tax": {' +
		'        "enabled": false,' +
		'        "liability": null,' +
		'        "status": null' +
		'      },' +
		'      "billing_reason": "subscription_cycle",' +
		'      "charge": "ch_3PCQhVCsC2AzqBfw0jAHtH2L",' +
		'      "collection_method": "charge_automatically",' +
		'      "created": 1730655576,' +
		'      "currency": "usd",' +
		'      "custom_fields": null,' +
		'      "customer": "cus_Q2V5bAWY4MnWds",' +
		'      "customer_address": {' +
		'        "city": "San Francisco",' +
		'        "country": "US",' +
		'        "line1": "123 Market Street",' +
		'        "line2": null,' +
		'        "postal_code": "94105",' +
		'        "state": "CA"' +
		'      },' +
		'      "customer_email": "test@test.com",' +
		'      "customer_name": "Jack Sparrow",' +
		'      "customer_phone": "+11231231234",' +
		'      "customer_shipping": null,' +
		'      "customer_tax_exempt": "none",' +
		'      "customer_tax_ids": [' +
		'      ],' +
		'      "default_payment_method": null,' +
		'      "default_source": null,' +
		'      "default_tax_rates": [' +
		'      ],' +
		'      "description": null,' +
		'      "discount": null,' +
		'      "discounts": [' +
		'      ],' +
		'      "due_date": null,' +
		'      "effective_at": 1730659140,' +
		'      "ending_balance": 0,' +
		'      "footer": null,' +
		'      "from_invoice": null,' +
		'      "hosted_invoice_url": "https://invoice.stripe.com/i/acct_1P9aDTCsC2AzqBfw/test_YWNjdF8xUDlhRFRDc0MyQXpxQmZ3LF9RMlZpRmtwYURFRFpLUXUwd2N4amdvQ0VYZzlCa2MxLDEwNTMwMTE1OQ0200tngqCcM2?s=ap",' +
		'      "invoice_pdf": "https://pay.stripe.com/invoice/acct_1P9aDTCsC2AzqBfw/test_YWNjdF8xUDlhRFRDc0MyQXpxQmZ3LF9RMlZpRmtwYURFRFpLUXUwd2N4amdvQ0VYZzlCa2MxLDEwNTMwMTE1OQ0200tngqCcM2/pdf?s=ap",' +
		'      "issuer": {' +
		'        "type": "self"' +
		'      },' +
		'      "last_finalization_error": null,' +
		'      "latest_revision": null,' +
		'      "lines": {' +
		'        "object": "list",' +
		'        "data": [' +
		'          {' +
		'            "id": "il_1QH7m0CsC2AzqBfwVWgEe9Rn",' +
		'            "object": "line_item",' +
		'            "amount": 7500,' +
		'            "amount_excluding_tax": 7500,' +
		'            "currency": "usd",' +
		'            "description": "1 × Donation (at $75.00 / every 3 months)",' +
		'            "discount_amounts": [' +
		'            ],' +
		'            "discountable": true,' +
		'            "discounts": [' +
		'            ],' +
		'            "invoice": "in_1PCQhFCsC2AzqBfwMcsai3Qa",' +
		'            "livemode": false,' +
		'            "metadata": {' +
		'            },' +
		'            "period": {' +
		'              "end": 1738604376,' +
		'              "start": 1730655576' +
		'            },' +
		'            "plan": {' +
		'              "id": "price_1PCQ52CsC2AzqBfwYnrBPI3O",' +
		'              "object": "plan",' +
		'              "active": false,' +
		'              "aggregate_usage": null,' +
		'              "amount": 7500,' +
		'              "amount_decimal": "7500",' +
		'              "billing_scheme": "per_unit",' +
		'              "created": 1714757972,' +
		'              "currency": "usd",' +
		'              "interval": "month",' +
		'              "interval_count": 3,' +
		'              "livemode": false,' +
		'              "metadata": {' +
		'              },' +
		'              "meter": null,' +
		'              "nickname": null,' +
		'              "product": "prod_PzzlXgEIpNHnPS",' +
		'              "tiers_mode": null,' +
		'              "transform_usage": null,' +
		'              "trial_period_days": null,' +
		'              "usage_type": "licensed"' +
		'            },' +
		'            "price": {' +
		'              "id": "price_1PCQ52CsC2AzqBfwYnrBPI3O",' +
		'              "object": "price",' +
		'              "active": false,' +
		'              "billing_scheme": "per_unit",' +
		'              "created": 1714757972,' +
		'              "currency": "usd",' +
		'              "custom_unit_amount": null,' +
		'              "livemode": false,' +
		'              "lookup_key": null,' +
		'              "metadata": {' +
		'              },' +
		'              "nickname": null,' +
		'              "product": "prod_PzzlXgEIpNHnPS",' +
		'              "recurring": {' +
		'                "aggregate_usage": null,' +
		'                "interval": "month",' +
		'                "interval_count": 3,' +
		'                "meter": null,' +
		'                "trial_period_days": null,' +
		'                "usage_type": "licensed"' +
		'              },' +
		'              "tax_behavior": "unspecified",' +
		'              "tiers_mode": null,' +
		'              "transform_quantity": null,' +
		'              "type": "recurring",' +
		'              "unit_amount": 7500,' +
		'              "unit_amount_decimal": "7500"' +
		'            },' +
		'            "proration": false,' +
		'            "proration_details": {' +
		'              "credited_items": null' +
		'            },' +
		'            "quantity": 1,' +
		'            "subscription": "sub_1PCQ56CsC2AzqBfwBDFiENa",' +
		'            "subscription_item": "si_Q2V5SdJqb8G10Y",' +
		'            "tax_amounts": [' +
		'            ],' +
		'            "tax_rates": [' +
		'            ],' +
		'            "type": "subscription",' +
		'            "unit_amount_excluding_tax": "7500"' +
		'          }' +
		'        ],' +
		'        "has_more": false,' +
		'        "total_count": 1,' +
		'        "url": "/v1/invoices/in_1PCQhFCsC2AzqBfwMcsai3Qa/lines"' +
		'      },' +
		'      "livemode": false,' +
		'      "metadata": {' +
		'      },' +
		'      "next_payment_attempt": null,' +
		'      "number": "061D0937-0003",' +
		'      "on_behalf_of": null,' +
		'      "paid": true,' +
		'      "paid_out_of_band": false,' +
		'      "payment_intent": "pi_3PCQhVCsC2AzqBfw0H1jUmLY",' +
		'      "payment_settings": {' +
		'        "default_mandate": null,' +
		'        "payment_method_options": {' +
		'          "acss_debit": null,' +
		'          "bancontact": null,' +
		'          "card": {' +
		'            "request_three_d_secure": "automatic"' +
		'          },' +
		'          "customer_balance": null,' +
		'          "konbini": null,' +
		'          "sepa_debit": null,' +
		'          "us_bank_account": null' +
		'        },' +
		'        "payment_method_types": null' +
		'      },' +
		'      "period_end": 1730655576,' +
		'      "period_start": 1722706776,' +
		'      "post_payment_credit_notes_amount": 0,' +
		'      "pre_payment_credit_notes_amount": 0,' +
		'      "quote": null,' +
		'      "receipt_number": null,' +
		'      "rendering": null,' +
		'      "shipping_cost": null,' +
		'      "shipping_details": null,' +
		'      "starting_balance": 0,' +
		'      "statement_descriptor": null,' +
		'      "status": "paid",' +
		'      "status_transitions": {' +
		'        "finalized_at": 1730659140,' +
		'        "marked_uncollectible_at": null,' +
		'        "paid_at": 1730659140,' +
		'        "voided_at": null' +
		'      },' +
		'      "subscription": "sub_1PCQ56CsC2AzqBfwBDFiENa",' +
		'      "subscription_details": {' +
		'        "metadata": {' +
		'        }' +
		'      },' +
		'      "subtotal": 7500,' +
		'      "subtotal_excluding_tax": 7500,' +
		'      "tax": null,' +
		'      "test_clock": "clock_1PCQe2CsC2AzqBfwILZm8naF",' +
		'      "total": 7500,' +
		'      "total_discount_amounts": [' +
		'      ],' +
		'      "total_excluding_tax": 7500,' +
		'      "total_tax_amounts": [' +
		'      ],' +
		'      "transfer_data": null,' +
		'      "webhooks_delivered_at": 1730655576' +
		'    }' +
		'  },' +
		'  "livemode": false,' +
		'  "pending_webhooks": 1,' +
		'  "request": {' +
		'    "id": "req_7LT8KP59N7q4G7",' +
		'    "idempotency_key": "e46c9b98-fada-41f7-98b0-db6a980143cf"' +
		'  },' +
		'  "type": "invoice.payment_succeeded"' +
		'}';

    static String oneTimeCheckout =
        '{'+
		'  "id": "evt_1PCVreCsC2AzqBfwWhZK2QqN",'+
		'  "object": "event",'+
		'  "api_version": "2024-04-10",'+
		'  "created": 1714780206,'+
		'  "data": {'+
		'    "object": {'+
		'      "id": "cs_test_a1wsZReFiLPUaN4RHASlR8QqFjc0lckUZ3fvLfKFtZlR9hTbsXIg08qPKY",'+
		'      "object": "checkout.session",'+
		'      "after_expiration": null,'+
		'      "allow_promotion_codes": null,'+
		'      "amount_subtotal": 2500,'+
		'      "amount_total": 2500,'+
		'      "automatic_tax": {'+
		'        "enabled": false,'+
		'        "liability": null,'+
		'        "status": null'+
		'      },'+
		'      "billing_address_collection": "required",'+
		'      "cancel_url": "https://peopleincorporated--dev.sandbox.lightning.force.com",'+
		'      "client_reference_id": null,'+
		'      "client_secret": null,'+
		'      "consent": null,'+
		'      "consent_collection": null,'+
		'      "created": 1714780139,'+
		'      "currency": "usd",'+
		'      "currency_conversion": null,'+
		'      "custom_fields": ['+
		'      ],'+
		'      "custom_text": {'+
		'        "after_submit": null,'+
		'        "shipping_address": null,'+
		'        "submit": null,'+
		'        "terms_of_service_acceptance": null'+
		'      },'+
		'      "customer": null,'+
		'      "customer_creation": "if_required",'+
		'      "customer_details": {'+
		'        "address": {'+
		'          "city": "Salinas",'+
		'          "country": "US",'+
		'          "line1": "123 West Market Street",'+
		'          "line2": null,'+
		'          "postal_code": "93901",'+
		'          "state": "CA"'+
		'        },'+
		'        "email": "peter@quil.com",'+
		'        "name": "Peter Quil",'+
		'        "phone": "+18055987894",'+
		'        "tax_exempt": "none",'+
		'        "tax_ids": ['+
		'        ]'+
		'      },'+
		'      "customer_email": null,'+
		'      "expires_at": 1714866539,'+
		'      "invoice": null,'+
		'      "invoice_creation": {'+
		'        "enabled": false,'+
		'        "invoice_data": {'+
		'          "account_tax_ids": null,'+
		'          "custom_fields": null,'+
		'          "description": null,'+
		'          "footer": null,'+
		'          "issuer": null,'+
		'          "metadata": {'+
		'          },'+
		'          "rendering_options": null'+
		'        }'+
		'      },'+
		'      "livemode": false,'+
		'      "locale": null,'+
		'      "metadata": {'+
		'        "campaignId": "undefined",'+
		'        "honoree": "{\\"FirstName\\":\\"Jack\\",\\"LastName\\":\\"Sparrow\\",\\"Street\\":\\"123 Test Ave\\",\\"City\\":\\"Test\\",\\"Zip\\":\\"12345\\",\\"Email\\":\\"jack@sparrow.com\\",\\"Phone\\":\\"1239874561\\",\\"State\\":\\"Arizona\\",\\"hasHonor\\":true,\\"honorType\\":\\"honor\\"}",'+
		'        "anonymous": "true",'+
		'        "recurrence": "{\\"isRecurring\\":false,\\"interval\\":\\"once\\",\\"intervalCount\\":1}"'+
		'      },'+
		'      "mode": "payment",'+
		'      "payment_intent": "pi_3PCVrdCsC2AzqBfw1dqAYLC3",'+
		'      "payment_link": null,'+
		'      "payment_method_collection": "if_required",'+
		'      "payment_method_configuration_details": null,'+
		'      "payment_method_options": {'+
		'        "card": {'+
		'          "request_three_d_secure": "automatic"'+
		'        }'+
		'      },'+
		'      "payment_method_types": ['+
		'        "card"'+
		'      ],'+
		'      "payment_status": "paid",'+
		'      "phone_number_collection": {'+
		'        "enabled": true'+
		'      },'+
		'      "recovered_from": null,'+
		'      "saved_payment_method_options": null,'+
		'      "setup_intent": null,'+
		'      "shipping_address_collection": null,'+
		'      "shipping_cost": null,'+
		'      "shipping_details": null,'+
		'      "shipping_options": ['+
		'      ],'+
		'      "status": "complete",'+
		'      "submit_type": null,'+
		'      "subscription": null,'+
		'      "success_url": "https://peopleincorporated--dev.sandbox.lightning.force.com",'+
		'      "total_details": {'+
		'        "amount_discount": 0,'+
		'        "amount_shipping": 0,'+
		'        "amount_tax": 0'+
		'      },'+
		'      "ui_mode": "hosted",'+
		'      "url": null'+
		'    }'+
		'  },'+
		'  "livemode": false,'+
		'  "pending_webhooks": 1,'+
		'  "request": {'+
		'    "id": null,'+
		'    "idempotency_key": null'+
		'  },'+
		'  "type": "checkout.session.completed"'+
		'}';
    
    private static void makeData() {
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Standard'].Id
        );
        insert con;

        npe03__Recurring_Donation__c recurring = new npe03__Recurring_Donation__c(
            npe03__Contact__c = con.Id,
            Name = 'Test Donation',
            npe03__Date_Established__c = Date.today(),
            npe03__Amount__c = 75,
            npsp__RecurringType__c = 'Open',
            npe03__Installment_Period__c = 'Monthly',
            npsp__Day_of_Month__c = Date.today().day().toString(),
            npsp__StartDate__c = Date.today(),
            Stripe_Subscription_Id__c = 'sub_1PCQ56CsC2AzqBfwBDFiENa'
        );
        insert recurring;
    }

    private static void makeData2() {
        camp = new Campaign(
            Name = 'Test Campaign',
            isActive = true
        );
        insert camp;
    }

	@isTest
	private static void recurringInitializationTest() {
		req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestURI = '/services/apexrest/stripe-checkout';

		req.requestBody = Blob.valueOf(recurringCheckout);
		restContext.request = req;

        StripeCallbackResource.doPost();

        npe03__Recurring_Donation__c donation = [
            SELECT Id
            FROM npe03__Recurring_Donation__c
            WHERE Stripe_Subscription_Id__c = 'sub_1PCQ56CsC2AzqBfwBDFiENa'
        ];

        Opportunity opp = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Stripe_Transaction_Id__c = 'in_1PCQ56CsC2AzqBfweyhWVdJ'
        ];

        npe01__OppPayment__c pmnt = [
            SELECT Id, npe01__Paid__c
            FROM npe01__OppPayment__c
            WHERE npe01__Opportunity__c = :opp.Id
        ];

        System.assert(donation.Id != null, 'No recurring donation created.');
        System.assertEquals(true, pmnt.npe01__Paid__c, 'Donation not collected.');
	}

    @IsTest
    private static void recurringSecondPaymentTest(){
        makeData();
        req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/services/apexrest/stripe-invoice';
        req.requestBody = Blob.valueOf(invoice);
        restContext.request = req;

        StripeInvoiceCallbackResource.doPost();
        
        Opportunity opp = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Stripe_Transaction_Id__c = 'in_1PCQhFCsC2AzqBfwMcsai3Qa'
        ];

        npe01__OppPayment__c pmnt = [
            SELECT Id, npe01__Paid__c
            FROM npe01__OppPayment__c
            WHERE npe01__Opportunity__c = :opp.Id
        ];

        System.assertEquals(true, pmnt.npe01__Paid__c, 'Donation not collected.');
    }

    @isTest
    private static void singlePaymentTest() {
        makeData2();
        oneTimeCheckout = oneTimeCheckout.replace('"campaignId": "undefined"', '"campaignId": "' + camp.Id + '"');

        req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = 'services/apexrest/stripe-checkout';
        req.requestBody = Blob.valueOf(oneTimeCheckout);
        RestContext.request = req;

        StripeCallbackResource.doPost();

        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            WHERE Stripe_Transaction_Id__c = 'cs_test_a1wsZReFiLPUaN4RHASlR8QqFjc0lckUZ3fvLfKFtZlR9hTbsXIg08qPKY'
        ];

        npe01__OppPayment__c pmnt = [
            SELECT Id, npe01__Paid__c
            FROM npe01__OppPayment__c
            WHERE npe01__Opportunity__c = :opp.Id
        ];

        System.assertEquals(true, pmnt.npe01__Paid__c, 'Donation not collected.');
    }
}
