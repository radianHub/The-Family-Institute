@isTest
public class StripeTestDataFactory {
	private String campaignId;
	private String oscId;
	public StripeTestDataFactory() {
	}
	public StripeTestDataFactory(String campaignId, String oscId) {
		this.campaignId = campaignId;
		this.oscId = oscId;
	}

	private Blob generateBlob(String json) {
		return Blob.valueOf(json);
	}

	public Blob oneTimeDonationOrg() {
		String campaignId = String.isNotBlank(campaignId) ? '"' + campaignId + '"' : '"undefined"';
		String oscId = String.isNotBlank(oscId) ? '"' + oscId + '"' : '"undefined"';
		return generateBlob(
			'{' +
				'  "id": "evt_1QbvTgCsC2AzqBfwL9yjVwzw",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1735613200,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "cs_test_a1nhMHlH14eWvbtYTudZqBbqc1dmY4tEIdyp0Fg6Yfnd9qtYyv0ZJPmN7Z",' +
				'      "object": "checkout.session",' +
				'      "adaptive_pricing": {' +
				'        "enabled": false' +
				'      },' +
				'      "after_expiration": null,' +
				'      "allow_promotion_codes": null,' +
				'      "amount_subtotal": 2500,' +
				'      "amount_total": 2500,' +
				'      "automatic_tax": {' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "billing_address_collection": "required",' +
				'      "cancel_url": null,' +
				'      "client_reference_id": null,' +
				'      "client_secret": null,' +
				'      "consent": null,' +
				'      "consent_collection": null,' +
				'      "created": 1735613193,' +
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
				'      "customer": null,' +
				'      "customer_creation": "if_required",' +
				'      "customer_details": {' +
				'        "address": {' +
				'          "city": "San Francisco",' +
				'          "country": "US",' +
				'          "line1": "123 Market Street",' +
				'          "line2": null,' +
				'          "postal_code": "94105",' +
				'          "state": "CA"' +
				'        },' +
				'        "email": "zachary.csotya@radianhub.com",' +
				'        "name": "Zac Test",' +
				'        "phone": "+18055981583",' +
				'        "tax_exempt": "none",' +
				'        "tax_ids": [' +
				'        ]' +
				'      },' +
				'      "customer_email": null,' +
				'      "expires_at": 1735699593,' +
				'      "invoice": null,' +
				'      "invoice_creation": {' +
				'        "enabled": false,' +
				'        "invoice_data": {' +
				'          "account_tax_ids": null,' +
				'          "custom_fields": null,' +
				'          "description": null,' +
				'          "footer": null,' +
				'          "issuer": null,' +
				'          "metadata": {' +
				'          },' +
				'          "rendering_options": null' +
				'        }' +
				'      },' +
				'      "livemode": false,' +
				'      "locale": null,' +
				'      "metadata": {' +
				'        "campaignId": ' +
				campaignId +
				',' +
				'        "recurrence": "{\\"isRecurring\\":false,\\"interval\\":\\"once\\",\\"intervalCount\\":1}",' +
				'        "match": "{\\"isMatch\\":true,\\"employerInfo\\":{\\"employerName\\":\\"Test Employer\\"}}",' +
				'        "anonymous": "true",' +
				'        "organization": "{\\"isOrg\\":true,\\"orgInfo\\":{\\"orgName\\":\\"Test Organization\\",\\"Street\\":\\"123 Test Rd\\",\\"City\\":\\"Santa Fe\\",\\"Zip\\":\\"12345\\",\\"Phone\\":\\"123-456-6789\\",\\"State\\":\\"New Mexico\\"}}",' +
				'        "honoree": "{\\"isHonor\\":true,\\"honoreeInfo\\":{\\"FirstName\\":\\"Test\\",\\"LastName\\":\\"Memorial\\"},\\"honorType\\":\\"memorial\\"}",' +
				'        "oscId": ' +
				oscId +
				'      },' +
				'      "mode": "payment",' +
				'      "payment_intent": "pi_3QbvTdCsC2AzqBfw0XFpGlYX",' +
				'      "payment_link": null,' +
				'      "payment_method_collection": "if_required",' +
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
				'      "redirect_on_completion": "always",' +
				'      "return_url": "https://familyinstitute2--rhdev2.sandbox.my.site.com/donate",' +
				'      "saved_payment_method_options": null,' +
				'      "setup_intent": null,' +
				'      "shipping_address_collection": null,' +
				'      "shipping_cost": null,' +
				'      "shipping_details": null,' +
				'      "shipping_options": [' +
				'      ],' +
				'      "status": "complete",' +
				'      "submit_type": "donate",' +
				'      "subscription": null,' +
				'      "success_url": null,' +
				'      "total_details": {' +
				'        "amount_discount": 0,' +
				'        "amount_shipping": 0,' +
				'        "amount_tax": 0' +
				'      },' +
				'      "ui_mode": "embedded",' +
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
				'}'
		);
	}

	public Blob oneTimeDonationPerson() {
		String campaignId = String.isNotBlank(campaignId) ? '"' + campaignId + '"' : '"undefined"';
		String oscId = String.isNotBlank(oscId) ? '"' + oscId + '"' : '"undefined"';
		return generateBlob(
			'{' +
				'  "id": "evt_1QbxH4CsC2AzqBfwdr0WeecU",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1735620106,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "cs_test_a1skSX2xGoDRoSS6rJj7z7hUxdZWo3ZONefBxalsUzwAwiiyFr9DA8wHCw",' +
				'      "object": "checkout.session",' +
				'      "adaptive_pricing": {' +
				'        "enabled": false' +
				'      },' +
				'      "after_expiration": null,' +
				'      "allow_promotion_codes": null,' +
				'      "amount_subtotal": 2500,' +
				'      "amount_total": 2500,' +
				'      "automatic_tax": {' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "billing_address_collection": "required",' +
				'      "cancel_url": null,' +
				'      "client_reference_id": null,' +
				'      "client_secret": null,' +
				'      "consent": null,' +
				'      "consent_collection": null,' +
				'      "created": 1735620102,' +
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
				'      "customer": null,' +
				'      "customer_creation": "if_required",' +
				'      "customer_details": {' +
				'        "address": {' +
				'          "city": "San Francisco",' +
				'          "country": "US",' +
				'          "line1": "123 Market Street",' +
				'          "line2": null,' +
				'          "postal_code": "94105",' +
				'          "state": "CA"' +
				'        },' +
				'        "email": "zachary.csotya@radianhub.com",' +
				'        "name": "Zac Test",' +
				'        "phone": "+18055981583",' +
				'        "tax_exempt": "none",' +
				'        "tax_ids": [' +
				'        ]' +
				'      },' +
				'      "customer_email": null,' +
				'      "expires_at": 1735706501,' +
				'      "invoice": null,' +
				'      "invoice_creation": {' +
				'        "enabled": false,' +
				'        "invoice_data": {' +
				'          "account_tax_ids": null,' +
				'          "custom_fields": null,' +
				'          "description": null,' +
				'          "footer": null,' +
				'          "issuer": null,' +
				'          "metadata": {' +
				'          },' +
				'          "rendering_options": null' +
				'        }' +
				'      },' +
				'      "livemode": false,' +
				'      "locale": null,' +
				'      "metadata": {' +
				'        "campaignId": ' +
				campaignId +
				',' +
				'        "recurrence": "{\\"isRecurring\\":false,\\"interval\\":\\"once\\",\\"intervalCount\\":1}",' +
				'        "match": "{\\"isMatch\\":false,\\"employerInfo\\":{}}",' +
				'        "anonymous": "false",' +
				'        "organization": "{\\"isOrg\\":false,\\"orgInfo\\":{}}",' +
				'        "honoree": "{\\"isHonor\\":false,\\"honoreeInfo\\":{}}",' +
				'        "oscId": ' +
				oscId +
				'      },' +
				'      "mode": "payment",' +
				'      "payment_intent": "pi_3QbxH3CsC2AzqBfw0ysECbTa",' +
				'      "payment_link": null,' +
				'      "payment_method_collection": "if_required",' +
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
				'      "redirect_on_completion": "always",' +
				'      "return_url": "https://familyinstitute2--rhdev2.sandbox.my.site.com/donate",' +
				'      "saved_payment_method_options": null,' +
				'      "setup_intent": null,' +
				'      "shipping_address_collection": null,' +
				'      "shipping_cost": null,' +
				'      "shipping_details": null,' +
				'      "shipping_options": [' +
				'      ],' +
				'      "status": "complete",' +
				'      "submit_type": "donate",' +
				'      "subscription": null,' +
				'      "success_url": null,' +
				'      "total_details": {' +
				'        "amount_discount": 0,' +
				'        "amount_shipping": 0,' +
				'        "amount_tax": 0' +
				'      },' +
				'      "ui_mode": "embedded",' +
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
				'}'
		);
	}

	public Blob oneTimeDonationBadRequest() {
		String campaignId = String.isNotBlank(campaignId) ? '"' + campaignId + '"' : '"undefined"';
		String oscId = String.isNotBlank(oscId) ? '"' + oscId + '"' : '"undefined"';
		return generateBlob(
			'{' +
				'  "id": "evt_1QbxH4CsC2AzqBfwdr0WeecU",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1735620106,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "cs_test_a1skSX2xGoDRoSS6rJj7z7hUxdZWo3ZONefBxalsUzwAwiiyFr9DA8wHCw",' +
				'      "object": "checkout.session",' +
				'      "adaptive_pricing": {' +
				'        "enabled": false' +
				'      },' +
				'      "after_expiration": null,' +
				'      "allow_promotion_codes": null,' +
				'      "amount_subtotal": 2500,' +
				'      "amount_total": 2500,' +
				'      "automatic_tax": {' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "billing_address_collection": "required",' +
				'      "cancel_url": null,' +
				'      "client_reference_id": null,' +
				'      "client_secret": null,' +
				'      "consent": null,' +
				'      "consent_collection": null,' +
				'      "created": 1735620102,' +
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
				'      "customer": null,' +
				'      "customer_creation": "if_required",' +
				'      "customer_details": {' +
				'        "address": {' +
				'          "city": "San Francisco",' +
				'          "country": "US",' +
				'          "line1": "123 Market Street",' +
				'          "line2": null,' +
				'          "postal_code": "94105",' +
				'          "state": "CA"' +
				'        },' +
				'        "email": "zachary.csotya@radianhub.com",' +
				'        "name": "Zac Test",' +
				'        "phone": "+18055981583",' +
				'        "tax_exempt": "none",' +
				'        "tax_ids": [' +
				'        ]' +
				'      },' +
				'      "customer_email": null,' +
				'      "expires_at": 1735706501,' +
				'      "invoice": null,' +
				'      "invoice_creation": {' +
				'        "enabled": false,' +
				'        "invoice_data": {' +
				'          "account_tax_ids": null,' +
				'          "custom_fields": null,' +
				'          "description": null,' +
				'          "footer": null,' +
				'          "issuer": null,' +
				'          "metadata": {' +
				'          },' +
				'          "rendering_options": null' +
				'        }' +
				'      },' +
				'      "livemode": false,' +
				'      "locale": null,' +
				'      "metadata": {' +
				'        "campaignId": ' +
				campaignId +
				',' +
				'        "recurrence": "{\"isRecurring\":false,\"interval\":\"once\",\"intervalCount\":1}",' +
				'        "match": "{\"isMatch\":false,\"employerInfo\":{}}",' +
				'        "anonymous": "false",' +
				'        "organization": "{\"isOrg\":false,\"orgInfo\":{}}",' +
				'        "honoree": "{\"isHonor\":false,\"honoreeInfo\":{}}",' +
				'        "oscId": ' +
				oscId +
				'      },' +
				'      "mode": "payment",' +
				'      "payment_intent": "pi_3QbxH3CsC2AzqBfw0ysECbTa",' +
				'      "payment_link": null,' +
				'      "payment_method_collection": "if_required",' +
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
				'      "redirect_on_completion": "always",' +
				'      "return_url": "https://familyinstitute2--rhdev2.sandbox.my.site.com/donate",' +
				'      "saved_payment_method_options": null,' +
				'      "setup_intent": null,' +
				'      "shipping_address_collection": null,' +
				'      "shipping_cost": null,' +
				'      "shipping_details": null,' +
				'      "shipping_options": [' +
				'      ],' +
				'      "status": "complete",' +
				'      "submit_type": "donate",' +
				'      "subscription": null,' +
				'      "success_url": null,' +
				'      "total_details": {' +
				'        "amount_discount": 0,' +
				'        "amount_shipping": 0,' +
				'        "amount_tax": 0' +
				'      },' +
				'      "ui_mode": "embedded",' +
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
				'}'
		);
	}

	public Blob oneTimeDonationNoCustomerDetails() {
		String campaignId = String.isNotBlank(campaignId) ? '"' + campaignId + '"' : '"undefined"';
		String oscId = String.isNotBlank(oscId) ? '"' + oscId + '"' : '"undefined"';
		return generateBlob(
			'{' +
				'  "id": "evt_1QbxH4CsC2AzqBfwdr0WeecU",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1735620106,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "cs_test_a1skSX2xGoDRoSS6rJj7z7hUxdZWo3ZONefBxalsUzwAwiiyFr9DA8wHCw",' +
				'      "object": "checkout.session",' +
				'      "adaptive_pricing": {' +
				'        "enabled": false' +
				'      },' +
				'      "after_expiration": null,' +
				'      "allow_promotion_codes": null,' +
				'      "amount_subtotal": 2500,' +
				'      "amount_total": 2500,' +
				'      "automatic_tax": {' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "billing_address_collection": "required",' +
				'      "cancel_url": null,' +
				'      "client_reference_id": null,' +
				'      "client_secret": null,' +
				'      "consent": null,' +
				'      "consent_collection": null,' +
				'      "created": 1735620102,' +
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
				'      "customer": null,' +
				'      "customer_creation": "if_required",' +
				'      "customer_details": {' +
				'        "address": {' +
				'        }' +
				'      },' +
				'      "customer_email": null,' +
				'      "expires_at": 1735706501,' +
				'      "invoice": null,' +
				'      "invoice_creation": {' +
				'        "enabled": false,' +
				'        "invoice_data": {' +
				'          "account_tax_ids": null,' +
				'          "custom_fields": null,' +
				'          "description": null,' +
				'          "footer": null,' +
				'          "issuer": null,' +
				'          "metadata": {' +
				'          },' +
				'          "rendering_options": null' +
				'        }' +
				'      },' +
				'      "livemode": false,' +
				'      "locale": null,' +
				'      "metadata": {' +
				'        "campaignId": ' +
				campaignId +
				',' +
				'        "recurrence": "{\\"isRecurring\\":false,\\"interval\\":\\"once\\",\\"intervalCount\\":1}",' +
				'        "match": "{\\"isMatch\\":false,\\"employerInfo\\":{}}",' +
				'        "anonymous": "false",' +
				'        "organization": "{\\"isOrg\\":false,\\"orgInfo\\":{}}",' +
				'        "honoree": "{\\"isHonor\\":false,\\"honoreeInfo\\":{}}",' +
				'        "oscId": ' +
				oscId +
				'      },' +
				'      "mode": "payment",' +
				'      "payment_intent": "pi_3QbxH3CsC2AzqBfw0ysECbTa",' +
				'      "payment_link": null,' +
				'      "payment_method_collection": "if_required",' +
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
				'      "redirect_on_completion": "always",' +
				'      "return_url": "https://familyinstitute2--rhdev2.sandbox.my.site.com/donate",' +
				'      "saved_payment_method_options": null,' +
				'      "setup_intent": null,' +
				'      "shipping_address_collection": null,' +
				'      "shipping_cost": null,' +
				'      "shipping_details": null,' +
				'      "shipping_options": [' +
				'      ],' +
				'      "status": "complete",' +
				'      "submit_type": "donate",' +
				'      "subscription": null,' +
				'      "success_url": null,' +
				'      "total_details": {' +
				'        "amount_discount": 0,' +
				'        "amount_shipping": 0,' +
				'        "amount_tax": 0' +
				'      },' +
				'      "ui_mode": "embedded",' +
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
				'}'
		);
	}

	public Blob recurringDonationPerson() {
		String campaignId = String.isNotBlank(campaignId) ? '"' + campaignId + '"' : '"undefined"';
		String oscId = String.isNotBlank(oscId) ? '"' + oscId + '"' : '"undefined"';
		return generateBlob(
			'{' +
				'  "id": "evt_1QbnBcCsC2AzqBfwqUVCmpS8",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1735581327,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "cs_test_a1EDLxVO2Fu3TACip5IBJKfxs8QTMuKXObuJbAHaR1cD7LL9EikLMcSaXS",' +
				'      "object": "checkout.session",' +
				'      "adaptive_pricing": null,' +
				'      "after_expiration": null,' +
				'      "allow_promotion_codes": null,' +
				'      "amount_subtotal": 1000,' +
				'      "amount_total": 1000,' +
				'      "automatic_tax": {' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "billing_address_collection": "required",' +
				'      "cancel_url": null,' +
				'      "client_reference_id": null,' +
				'      "client_secret": null,' +
				'      "consent": null,' +
				'      "consent_collection": null,' +
				'      "created": 1735581320,' +
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
				'      "customer": "cus_RUmlIJJkzg8FFu",' +
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
				'        "email": "zachary.csotya@radianhub.com",' +
				'        "name": "Zac Test",' +
				'        "phone": "+18055981583",' +
				'        "tax_exempt": "none",' +
				'        "tax_ids": [' +
				'        ]' +
				'      },' +
				'      "customer_email": null,' +
				'      "expires_at": 1735667720,' +
				'      "invoice": "in_1QeKWhCsC2AzqBfwQvjedbhp",' +
				'      "invoice_creation": null,' +
				'      "livemode": false,' +
				'      "locale": null,' +
				'      "metadata": {' +
				'        "campaignId": ' +
				campaignId +
				',' +
				'        "recurrence": "{\\"isRecurring\\":true,\\"interval\\":\\"week\\",\\"intervalCount\\":1}",' +
				'        "match": "{\\"isMatch\\":false,\\"employerInfo\\":{}}",' +
				'        "anonymous": "false",' +
				'        "organization": "{\\"isOrg\\":false,\\"orgInfo\\":{}}",' +
				'        "honoree": "{\\"isHonor\\":true,\\"honoreeInfo\\":{\\"FirstName\\":\\"Test\\",\\"LastName\\":\\"Memorial\\"},\\"honorType\\":\\"memorial\\"}",' +
				'        "oscId": ' +
				oscId +
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
				'      "redirect_on_completion": "always",' +
				'      "return_url": "https://familyinstitute2--rhdev2.sandbox.my.site.com/donate",' +
				'      "saved_payment_method_options": {' +
				'        "allow_redisplay_filters": [' +
				'          "always"' +
				'        ],' +
				'        "payment_method_remove": null,' +
				'        "payment_method_save": null' +
				'      },' +
				'      "setup_intent": null,' +
				'      "shipping_address_collection": null,' +
				'      "shipping_cost": null,' +
				'      "shipping_details": null,' +
				'      "shipping_options": [' +
				'      ],' +
				'      "status": "complete",' +
				'      "submit_type": "donate",' +
				'      "subscription": "sub_1QbnBYCsC2AzqBfw3f9sBWWV",' +
				'      "success_url": null,' +
				'      "total_details": {' +
				'        "amount_discount": 0,' +
				'        "amount_shipping": 0,' +
				'        "amount_tax": 0' +
				'      },' +
				'      "ui_mode": "embedded",' +
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
				'}'
		);
	}

	public Blob invoicePerson() {
		return generateBlob(
			'{' +
				'  "id": "evt_1QeLTHCsC2AzqBfw5GXn0e7j",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1736189774,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "in_1QeKWhCsC2AzqBfwQvjedbhv",' +
				'      "object": "invoice",' +
				'      "account_country": "US",' +
				'      "account_name": "Zachary Csotya",' +
				'      "account_tax_ids": null,' +
				'      "amount_due": 1000,' +
				'      "amount_paid": 1000,' +
				'      "amount_remaining": 0,' +
				'      "amount_shipping": 0,' +
				'      "application": null,' +
				'      "application_fee_amount": null,' +
				'      "attempt_count": 1,' +
				'      "attempted": true,' +
				'      "auto_advance": false,' +
				'      "automatic_tax": {' +
				'        "disabled_reason": null,' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "automatically_finalizes_at": null,' +
				'      "billing_reason": "subscription_cycle",' +
				'      "charge": "ch_3QeLTDCsC2AzqBfw1DfDkmrq",' +
				'      "collection_method": "charge_automatically",' +
				'      "created": 1736186143,' +
				'      "currency": "usd",' +
				'      "custom_fields": null,' +
				'      "customer": "cus_RUmlIJJkzg8FFu",' +
				'      "customer_address": {' +
				'        "city": "San Francisco",' +
				'        "country": "US",' +
				'        "line1": "123 Market Street",' +
				'        "line2": null,' +
				'        "postal_code": "94105",' +
				'        "state": "CA"' +
				'      },' +
				'      "customer_email": "zachary.csotya@radianhub.com",' +
				'      "customer_name": "Zac Test",' +
				'      "customer_phone": "+18055981583",' +
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
				'      "effective_at": 1736189770,' +
				'      "ending_balance": 0,' +
				'      "footer": null,' +
				'      "from_invoice": null,' +
				'      "hosted_invoice_url": "https://invoice.stripe.com/i/acct_1P9aDTCsC2AzqBfw/test_YWNjdF8xUDlhRFRDc0MyQXpxQmZ3LF9SWFBMYVpUUTF6eTFySVhEM3VaaWF5MVpmWGV1SFFrLDEyNjczMDU3NQ0200O01F6UPV?s=ap",' +
				'      "invoice_pdf": "https://pay.stripe.com/invoice/acct_1P9aDTCsC2AzqBfw/test_YWNjdF8xUDlhRFRDc0MyQXpxQmZ3LF9SWFBMYVpUUTF6eTFySVhEM3VaaWF5MVpmWGV1SFFrLDEyNjczMDU3NQ0200O01F6UPV/pdf?s=ap",' +
				'      "issuer": {' +
				'        "type": "self"' +
				'      },' +
				'      "last_finalization_error": null,' +
				'      "latest_revision": null,' +
				'      "lines": {' +
				'        "object": "list",' +
				'        "data": [' +
				'          {' +
				'            "id": "il_1QeKWhCsC2AzqBfw7GnbSFLX",' +
				'            "object": "line_item",' +
				'            "amount": 1000,' +
				'            "amount_excluding_tax": 1000,' +
				'            "currency": "usd",' +
				'            "description": "1 × Donation (at $10.00 / week)",' +
				'            "discount_amounts": [' +
				'            ],' +
				'            "discountable": true,' +
				'            "discounts": [' +
				'            ],' +
				'            "invoice": "in_1QeKWhCsC2AzqBfwQvjedbhv",' +
				'            "livemode": false,' +
				'            "metadata": {' +
				'            },' +
				'            "period": {' +
				'              "end": 1736790924,' +
				'              "start": 1736186124' +
				'            },' +
				'            "plan": {' +
				'              "id": "price_1QbnBUCsC2AzqBfwKZmmfg4Z",' +
				'              "object": "plan",' +
				'              "active": false,' +
				'              "aggregate_usage": null,' +
				'              "amount": 1000,' +
				'              "amount_decimal": "1000",' +
				'              "billing_scheme": "per_unit",' +
				'              "created": 1735581320,' +
				'              "currency": "usd",' +
				'              "interval": "week",' +
				'              "interval_count": 1,' +
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
				'            "pretax_credit_amounts": [' +
				'            ],' +
				'            "price": {' +
				'              "id": "price_1QbnBUCsC2AzqBfwKZmmfg4Z",' +
				'              "object": "price",' +
				'              "active": false,' +
				'              "billing_scheme": "per_unit",' +
				'              "created": 1735581320,' +
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
				'                "interval": "week",' +
				'                "interval_count": 1,' +
				'                "meter": null,' +
				'                "trial_period_days": null,' +
				'                "usage_type": "licensed"' +
				'              },' +
				'              "tax_behavior": "unspecified",' +
				'              "tiers_mode": null,' +
				'              "transform_quantity": null,' +
				'              "type": "recurring",' +
				'              "unit_amount": 1000,' +
				'              "unit_amount_decimal": "1000"' +
				'            },' +
				'            "proration": false,' +
				'            "proration_details": {' +
				'              "credited_items": null' +
				'            },' +
				'            "quantity": 1,' +
				'            "subscription": "sub_1QbnBYCsC2AzqBfw3f9sBWWV",' +
				'            "subscription_item": "si_RUmlyDWZdvWM3z",' +
				'            "tax_amounts": [' +
				'            ],' +
				'            "tax_rates": [' +
				'            ],' +
				'            "type": "subscription",' +
				'            "unit_amount_excluding_tax": "1000"' +
				'          }' +
				'        ],' +
				'        "has_more": false,' +
				'        "total_count": 1,' +
				'        "url": "/v1/invoices/in_1QeKWhCsC2AzqBfwQvjedbhv/lines"' +
				'      },' +
				'      "livemode": false,' +
				'      "metadata": {' +
				'      },' +
				'      "next_payment_attempt": null,' +
				'      "number": "C5F15A61-0002",' +
				'      "on_behalf_of": null,' +
				'      "paid": true,' +
				'      "paid_out_of_band": false,' +
				'      "payment_intent": "pi_3QeLTDCsC2AzqBfw1NQ3Dnlc",' +
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
				'      "period_end": 1736186124,' +
				'      "period_start": 1735581324,' +
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
				'        "finalized_at": 1736189770,' +
				'        "marked_uncollectible_at": null,' +
				'        "paid_at": 1736189770,' +
				'        "voided_at": null' +
				'      },' +
				'      "subscription": "sub_1QbnBYCsC2AzqBfw3f9sBWWV",' +
				'      "subscription_details": {' +
				'        "metadata": {' +
				'        }' +
				'      },' +
				'      "subtotal": 1000,' +
				'      "subtotal_excluding_tax": 1000,' +
				'      "tax": null,' +
				'      "test_clock": null,' +
				'      "total": 1000,' +
				'      "total_discount_amounts": [' +
				'      ],' +
				'      "total_excluding_tax": 1000,' +
				'      "total_pretax_credit_amounts": [' +
				'      ],' +
				'      "total_tax_amounts": [' +
				'      ],' +
				'      "transfer_data": null,' +
				'      "webhooks_delivered_at": 1736186143' +
				'    }' +
				'  },' +
				'  "livemode": false,' +
				'  "pending_webhooks": 1,' +
				'  "request": {' +
				'    "id": null,' +
				'    "idempotency_key": null' +
				'  },' +
				'  "type": "invoice.payment_succeeded"' +
				'}'
		);
	}

	public Blob cancellation() {
		return generateBlob(
			'{' +
				'  "id": "evt_1QflFnCsC2AzqBfwFmInWYqf",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1736527211,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "sub_123456",' +
				'      "object": "subscription",' +
				'      "application": null,' +
				'      "application_fee_percent": null,' +
				'      "automatic_tax": {' +
				'        "disabled_reason": null,' +
				'        "enabled": false,' +
				'        "liability": null' +
				'      },' +
				'      "billing_cycle_anchor": 1735533184,' +
				'      "billing_cycle_anchor_config": null,' +
				'      "billing_thresholds": null,' +
				'      "cancel_at": null,' +
				'      "cancel_at_period_end": false,' +
				'      "canceled_at": 1736527210,' +
				'      "cancellation_details": {' +
				'        "comment": null,' +
				'        "feedback": null,' +
				'        "reason": "cancellation_requested"' +
				'      },' +
				'      "collection_method": "charge_automatically",' +
				'      "created": 1735533184,' +
				'      "currency": "usd",' +
				'      "current_period_end": 1738211584,' +
				'      "current_period_start": 1735533184,' +
				'      "customer": "cus_RUZoaop4dKe766",' +
				'      "days_until_due": null,' +
				'      "default_payment_method": "pm_1Qbaf5CsC2AzqBfwxyf6JFlR",' +
				'      "default_source": null,' +
				'      "default_tax_rates": [' +
				'      ],' +
				'      "description": null,' +
				'      "discount": null,' +
				'      "discounts": [' +
				'      ],' +
				'      "ended_at": 1736527210,' +
				'      "invoice_settings": {' +
				'        "account_tax_ids": null,' +
				'        "issuer": {' +
				'          "type": "self"' +
				'        }' +
				'      },' +
				'      "items": {' +
				'        "object": "list",' +
				'        "data": [' +
				'          {' +
				'            "id": "si_RUZoGIhJ05JmOi",' +
				'            "object": "subscription_item",' +
				'            "billing_thresholds": null,' +
				'            "created": 1735533185,' +
				'            "discounts": [' +
				'            ],' +
				'            "metadata": {' +
				'            },' +
				'            "plan": {' +
				'              "id": "price_1Qbaf2CsC2AzqBfwgpi8KZfs",' +
				'              "object": "plan",' +
				'              "active": false,' +
				'              "aggregate_usage": null,' +
				'              "amount": 500,' +
				'              "amount_decimal": "500",' +
				'              "billing_scheme": "per_unit",' +
				'              "created": 1735533180,' +
				'              "currency": "usd",' +
				'              "interval": "month",' +
				'              "interval_count": 1,' +
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
				'              "id": "price_1Qbaf2CsC2AzqBfwgpi8KZfs",' +
				'              "object": "price",' +
				'              "active": false,' +
				'              "billing_scheme": "per_unit",' +
				'              "created": 1735533180,' +
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
				'                "interval_count": 1,' +
				'                "meter": null,' +
				'                "trial_period_days": null,' +
				'                "usage_type": "licensed"' +
				'              },' +
				'              "tax_behavior": "unspecified",' +
				'              "tiers_mode": null,' +
				'              "transform_quantity": null,' +
				'              "type": "recurring",' +
				'              "unit_amount": 500,' +
				'              "unit_amount_decimal": "500"' +
				'            },' +
				'            "quantity": 1,' +
				'            "subscription": "sub_1Qbaf6CsC2AzqBfwDvf2QQBF",' +
				'            "tax_rates": [' +
				'            ]' +
				'          }' +
				'        ],' +
				'        "has_more": false,' +
				'        "total_count": 1,' +
				'        "url": "/v1/subscription_items?subscription=sub_1Qbaf6CsC2AzqBfwDvf2QQBF"' +
				'      },' +
				'      "latest_invoice": "in_1Qbaf6CsC2AzqBfw1jFhmvYj",' +
				'      "livemode": false,' +
				'      "metadata": {' +
				'      },' +
				'      "next_pending_invoice_item_invoice": null,' +
				'      "on_behalf_of": null,' +
				'      "pause_collection": null,' +
				'      "payment_settings": {' +
				'        "payment_method_options": {' +
				'          "acss_debit": null,' +
				'          "bancontact": null,' +
				'          "card": {' +
				'            "network": null,' +
				'            "request_three_d_secure": "automatic"' +
				'          },' +
				'          "customer_balance": null,' +
				'          "konbini": null,' +
				'          "sepa_debit": null,' +
				'          "us_bank_account": null' +
				'        },' +
				'        "payment_method_types": null,' +
				'        "save_default_payment_method": "off"' +
				'      },' +
				'      "pending_invoice_item_interval": null,' +
				'      "pending_setup_intent": null,' +
				'      "pending_update": null,' +
				'      "plan": {' +
				'        "id": "price_1Qbaf2CsC2AzqBfwgpi8KZfs",' +
				'        "object": "plan",' +
				'        "active": false,' +
				'        "aggregate_usage": null,' +
				'        "amount": 500,' +
				'        "amount_decimal": "500",' +
				'        "billing_scheme": "per_unit",' +
				'        "created": 1735533180,' +
				'        "currency": "usd",' +
				'        "interval": "month",' +
				'        "interval_count": 1,' +
				'        "livemode": false,' +
				'        "metadata": {' +
				'        },' +
				'        "meter": null,' +
				'        "nickname": null,' +
				'        "product": "prod_PzzlXgEIpNHnPS",' +
				'        "tiers_mode": null,' +
				'        "transform_usage": null,' +
				'        "trial_period_days": null,' +
				'        "usage_type": "licensed"' +
				'      },' +
				'      "quantity": 1,' +
				'      "schedule": null,' +
				'      "start_date": 1735533184,' +
				'      "status": "canceled",' +
				'      "test_clock": null,' +
				'      "transfer_data": null,' +
				'      "trial_end": null,' +
				'      "trial_settings": {' +
				'        "end_behavior": {' +
				'          "missing_payment_method": "create_invoice"' +
				'        }' +
				'      },' +
				'      "trial_start": null' +
				'    }' +
				'  },' +
				'  "livemode": false,' +
				'  "pending_webhooks": 1,' +
				'  "request": {' +
				'    "id": "req_tDzPkUf7JnQ4DA",' +
				'    "idempotency_key": null' +
				'  },' +
				'  "type": "customer.subscription.deleted"' +
				'}'
		);
	}

	public Blob oneTimeTicketPurchase() {
		String campaignId = String.isNotBlank(campaignId) ? '"' + campaignId + '"' : '"undefined"';
		return generateBlob(
			'{' +
				'  "id": "evt_1R5AR5CsC2AzqBfwWKw5o0sj",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1742582211,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "cs_test_a1fCSaX1yvRKgChgIDS1YQvreztdlKpzQpYXDR7BbUtBVDZHsHPJcBVT1N",' +
				'      "object": "checkout.session",' +
				'      "adaptive_pricing": {' +
				'        "enabled": false' +
				'      },' +
				'      "after_expiration": null,' +
				'      "allow_promotion_codes": null,' +
				'      "amount_subtotal": 12300,' +
				'      "amount_total": 12300,' +
				'      "automatic_tax": {' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "billing_address_collection": null,' +
				'      "cancel_url": null,' +
				'      "client_reference_id": null,' +
				'      "client_secret": null,' +
				'      "collected_information": {' +
				'        "shipping_details": null' +
				'      },' +
				'      "consent": null,' +
				'      "consent_collection": null,' +
				'      "created": 1742582180,' +
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
				'      "customer": null,' +
				'      "customer_creation": "if_required",' +
				'      "customer_details": {' +
				'        "address": {' +
				'          "city": null,' +
				'          "country": "US",' +
				'          "line1": null,' +
				'          "line2": null,' +
				'          "postal_code": "12345",' +
				'          "state": null' +
				'        },' +
				'        "email": "babyt@mailinator.com",' +
				'        "name": "abc",' +
				'        "phone": null,' +
				'        "tax_exempt": "none",' +
				'        "tax_ids": [' +
				'        ]' +
				'      },' +
				'      "customer_email": "babyt@mailinator.com",' +
				'      "discounts": [' +
				'      ],' +
				'      "expires_at": 1742668579,' +
				'      "invoice": null,' +
				'      "invoice_creation": {' +
				'        "enabled": false,' +
				'        "invoice_data": {' +
				'          "account_tax_ids": null,' +
				'          "custom_fields": null,' +
				'          "description": null,' +
				'          "footer": null,' +
				'          "issuer": null,' +
				'          "metadata": {' +
				'          },' +
				'          "rendering_options": null' +
				'        }' +
				'      },' +
				'      "livemode": false,' +
				'      "locale": null,' +
				'      "metadata": {' +
				'        "payer": "{\\"firstName\\":\\"Josiah\\",\\"lastName\\":\\"Fleming\\",\\"street\\":\\"Stacy Mcgowan\\",\\"city\\":\\"Knox Gates\\",\\"state\\":\\"Arizona\\",\\"zip\\":\\"12345\\",\\"email\\":\\"babyt@mailinator.com\\",\\"phone\\":\\"+1 (549) 224-6009\\"}",' +
				'        "campaignId": ' +
				campaignId +
				',' +
				'        "type": "ticketing",' +
				'        "recurrence": "{\\"isRecurring\\":false,\\"interval\\":\\"once\\",\\"intervalCount\\":1}",' +
				'        "match": "{\\"isMatch\\":false,\\"employerInfo\\":{}}",' +
				'        "organization": "{\\"isOrg\\":false,\\"orgInfo\\":{}}",' +
				'        "anonymous": "false",' +
				'        "honoree": "{\\"isHonor\\":false,\\"honoreeInfo\\":{}}",' +
				'        "oscId": "undefined"' +
				'      },' +
				'      "mode": "payment",' +
				'      "payment_intent": "pi_3R5AR4CsC2AzqBfw08xGADcu",' +
				'      "payment_link": null,' +
				'      "payment_method_collection": "if_required",' +
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
				'      "permissions": null,' +
				'      "phone_number_collection": {' +
				'        "enabled": false' +
				'      },' +
				'      "recovered_from": null,' +
				'      "redirect_on_completion": "if_required",' +
				'      "return_url": "https://familyinstitute2--rhdev2.sandbox.my.site.com/ticket",' +
				'      "saved_payment_method_options": null,' +
				'      "setup_intent": null,' +
				'      "shipping_address_collection": null,' +
				'      "shipping_cost": null,' +
				'      "shipping_details": null,' +
				'      "shipping_options": [' +
				'      ],' +
				'      "status": "complete",' +
				'      "submit_type": "pay",' +
				'      "subscription": null,' +
				'      "success_url": null,' +
				'      "total_details": {' +
				'        "amount_discount": 0,' +
				'        "amount_shipping": 0,' +
				'        "amount_tax": 0' +
				'      },' +
				'      "ui_mode": "embedded",' +
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
				'}'
		);
	}

	public Blob recurringTicketPurchase() {
		String campaignId = String.isNotBlank(campaignId) ? '"' + campaignId + '"' : 'undefined';
		return generateBlob(
			'{' +
				'  "id": "evt_1R5FL3CsC2AzqBfw82sRovg3",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1742601057,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "cs_test_a1qhvwTb9eDPzgh8uoFmQ2TeMMWbZAejbLQEeedoEwQgMnTurK7XLYDLIW",' +
				'      "object": "checkout.session",' +
				'      "adaptive_pricing": null,' +
				'      "after_expiration": null,' +
				'      "allow_promotion_codes": null,' +
				'      "amount_subtotal": 6150,' +
				'      "amount_total": 6150,' +
				'      "automatic_tax": {' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "billing_address_collection": null,' +
				'      "cancel_url": null,' +
				'      "client_reference_id": null,' +
				'      "client_secret": null,' +
				'      "collected_information": {' +
				'        "shipping_details": null' +
				'      },' +
				'      "consent": null,' +
				'      "consent_collection": null,' +
				'      "created": 1742600762,' +
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
				'      "customer": "cus_RzDmunUUb9MbLC",' +
				'      "customer_creation": "always",' +
				'      "customer_details": {' +
				'        "address": {' +
				'          "city": null,' +
				'          "country": "US",' +
				'          "line1": null,' +
				'          "line2": null,' +
				'          "postal_code": "12345",' +
				'          "state": null' +
				'        },' +
				'        "email": "pupil@mailinator.com",' +
				'        "name": "abc",' +
				'        "phone": null,' +
				'        "tax_exempt": "none",' +
				'        "tax_ids": [' +
				'        ]' +
				'      },' +
				'      "customer_email": "pupil@mailinator.com",' +
				'      "discounts": [' +
				'      ],' +
				'      "expires_at": 1742687162,' +
				'      "invoice": "in_1R5FKzCsC2AzqBfwD4TtcyUl",' +
				'      "invoice_creation": null,' +
				'      "livemode": false,' +
				'      "locale": null,' +
				'      "metadata": {' +
				'        "payer": "{\\"firstName\\":\\"Wyatt\\",\\"lastName\\":\\"Puckett\\",\\"street\\":\\"Arden Donovan\\",\\"city\\":\\"Germane Weaver\\",\\"state\\":\\"Arizona\\",\\"zip\\":\\"12345\\",\\"email\\":\\"pupil@mailinator.com\\",\\"phone\\":\\"+1 (595) 532-8042\\"}",' +
				'        "campaignId":' +
				campaignId +
				',' +
				'        "type": "ticketing",' +
				'        "paymentLength": "6",' +
				'        "recurrence": "{\\"isRecurring\\":false,\\"interval\\":\\"once\\",\\"intervalCount\\":1}",' +
				'        "match": "{\\"isMatch\\":false,\\"employerInfo\\":{}}",' +
				'        "anonymous": "false",' +
				'        "organization": "{\\"isOrg\\":false,\\"orgInfo\\":{}}",' +
				'        "honoree": "{\\"isHonor\\":false,\\"honoreeInfo\\":{}}",' +
				'        "oscId": "undefined"' +
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
				'      "permissions": null,' +
				'      "phone_number_collection": {' +
				'        "enabled": false' +
				'      },' +
				'      "recovered_from": null,' +
				'      "redirect_on_completion": "if_required",' +
				'      "return_url": "https://familyinstitute2--rhdev2.sandbox.my.site.com/ticket",' +
				'      "saved_payment_method_options": {' +
				'        "allow_redisplay_filters": [' +
				'          "always"' +
				'        ],' +
				'        "payment_method_remove": null,' +
				'        "payment_method_save": null' +
				'      },' +
				'      "setup_intent": null,' +
				'      "shipping_address_collection": null,' +
				'      "shipping_cost": null,' +
				'      "shipping_details": null,' +
				'      "shipping_options": [' +
				'      ],' +
				'      "status": "complete",' +
				'      "submit_type": "subscribe",' +
				'      "subscription": "sub_1R5FKzCsC2AzqBfwgBuO9Gf7",' +
				'      "success_url": null,' +
				'      "total_details": {' +
				'        "amount_discount": 0,' +
				'        "amount_shipping": 0,' +
				'        "amount_tax": 0' +
				'      },' +
				'      "ui_mode": "embedded",' +
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
				'}'
		);
	}

	public Blob invoiceTicket() {
		return generateBlob(
			'{' +
				'  "id": "evt_1R5FL4CsC2AzqBfwZI48YqQZ",' +
				'  "object": "event",' +
				'  "api_version": "2024-04-10",' +
				'  "created": 1742601056,' +
				'  "data": {' +
				'    "object": {' +
				'      "id": "in_1R5FKzCsC2AzqBfwD4TtcyUl",' +
				'      "object": "invoice",' +
				'      "account_country": "US",' +
				'      "account_name": "Zachary Csotya",' +
				'      "account_tax_ids": null,' +
				'      "amount_due": 6150,' +
				'      "amount_overpaid": 0,' +
				'      "amount_paid": 6150,' +
				'      "amount_remaining": 0,' +
				'      "amount_shipping": 0,' +
				'      "application": null,' +
				'      "application_fee_amount": null,' +
				'      "attempt_count": 1,' +
				'      "attempted": true,' +
				'      "auto_advance": false,' +
				'      "automatic_tax": {' +
				'        "disabled_reason": null,' +
				'        "enabled": false,' +
				'        "liability": null,' +
				'        "status": null' +
				'      },' +
				'      "automatically_finalizes_at": null,' +
				'      "billing_reason": "subscription_create",' +
				'      "charge": "ch_3R5FL0CsC2AzqBfw1PMamZNk",' +
				'      "collection_method": "charge_automatically",' +
				'      "created": 1742601053,' +
				'      "currency": "usd",' +
				'      "custom_fields": null,' +
				'      "customer": "cus_RzDmunUUb9MbLC",' +
				'      "customer_address": {' +
				'        "city": null,' +
				'        "country": "US",' +
				'        "line1": null,' +
				'        "line2": null,' +
				'        "postal_code": "12345",' +
				'        "state": null' +
				'      },' +
				'      "customer_email": "pupil@mailinator.com",' +
				'      "customer_name": "abc",' +
				'      "customer_phone": null,' +
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
				'      "effective_at": 1742601053,' +
				'      "ending_balance": 0,' +
				'      "footer": null,' +
				'      "from_invoice": null,' +
				'      "hosted_invoice_url": "https://invoice.stripe.com/i/acct_1P9aDTCsC2AzqBfw/test_YWNjdF8xUDlhRFRDc0MyQXpxQmZ3LF9SekRtbHFlbGFmU012RVVGVWh1VFJmcWJ3TTJHYVdELDEzMzE0MTg1OA0200Sosyo30l?s=ap",' +
				'      "invoice_pdf": "https://pay.stripe.com/invoice/acct_1P9aDTCsC2AzqBfw/test_YWNjdF8xUDlhRFRDc0MyQXpxQmZ3LF9SekRtbHFlbGFmU012RVVGVWh1VFJmcWJ3TTJHYVdELDEzMzE0MTg1OA0200Sosyo30l/pdf?s=ap",' +
				'      "issuer": {' +
				'        "type": "self"' +
				'      },' +
				'      "last_finalization_error": null,' +
				'      "latest_revision": null,' +
				'      "lines": {' +
				'        "object": "list",' +
				'        "data": [' +
				'          {' +
				'            "id": "il_1R5FKzCsC2AzqBfwlltENWct",' +
				'            "object": "line_item",' +
				'            "amount": 6150,' +
				'            "amount_excluding_tax": 6150,' +
				'            "currency": "usd",' +
				'            "description": "3 × Registration(s): Test Event (at $20.50 / month)",' +
				'            "discount_amounts": [' +
				'            ],' +
				'            "discountable": true,' +
				'            "discounts": [' +
				'            ],' +
				'            "invoice": "in_1R5FKzCsC2AzqBfwD4TtcyUl",' +
				'            "livemode": false,' +
				'            "metadata": {' +
				'              "isTicket": "true"' +
				'            },' +
				'            "parent": {' +
				'              "invoice_item_details": null,' +
				'              "subscription_item_details": {' +
				'                "invoice_item": null,' +
				'                "proration": false,' +
				'                "proration_details": {' +
				'                  "credited_items": null' +
				'                },' +
				'                "subscription": "sub_1R5FKzCsC2AzqBfwgBuO9Gf7",' +
				'                "subscription_item": "si_RzDm1mHU3jd1KD"' +
				'              },' +
				'              "type": "subscription_item_details"' +
				'            },' +
				'            "period": {' +
				'              "end": 1745279453,' +
				'              "start": 1742601053' +
				'            },' +
				'            "plan": {' +
				'              "id": "price_1R5FGICsC2AzqBfwVvkNZDhK",' +
				'              "object": "plan",' +
				'              "active": false,' +
				'              "aggregate_usage": null,' +
				'              "amount": 2050,' +
				'              "amount_decimal": "2050",' +
				'              "billing_scheme": "per_unit",' +
				'              "created": 1742600762,' +
				'              "currency": "usd",' +
				'              "interval": "month",' +
				'              "interval_count": 1,' +
				'              "livemode": false,' +
				'              "metadata": {' +
				'              },' +
				'              "meter": null,' +
				'              "nickname": null,' +
				'              "product": "prod_RwF614tzzCNI8d",' +
				'              "tiers_mode": null,' +
				'              "transform_usage": null,' +
				'              "trial_period_days": null,' +
				'              "usage_type": "licensed"' +
				'            },' +
				'            "pretax_credit_amounts": [' +
				'            ],' +
				'            "price": {' +
				'              "id": "price_1R5FGICsC2AzqBfwVvkNZDhK",' +
				'              "object": "price",' +
				'              "active": false,' +
				'              "billing_scheme": "per_unit",' +
				'              "created": 1742600762,' +
				'              "currency": "usd",' +
				'              "custom_unit_amount": null,' +
				'              "livemode": false,' +
				'              "lookup_key": null,' +
				'              "metadata": {' +
				'              },' +
				'              "nickname": null,' +
				'              "product": "prod_RwF614tzzCNI8d",' +
				'              "recurring": {' +
				'                "aggregate_usage": null,' +
				'                "interval": "month",' +
				'                "interval_count": 1,' +
				'                "meter": null,' +
				'                "trial_period_days": null,' +
				'                "usage_type": "licensed"' +
				'              },' +
				'              "tax_behavior": "unspecified",' +
				'              "tiers_mode": null,' +
				'              "transform_quantity": null,' +
				'              "type": "recurring",' +
				'              "unit_amount": 2050,' +
				'              "unit_amount_decimal": "2050"' +
				'            },' +
				'            "proration": false,' +
				'            "proration_details": {' +
				'              "credited_items": null' +
				'            },' +
				'            "quantity": 3,' +
				'            "subscription": "sub_1R5FKzCsC2AzqBfwgBuO9Gf7",' +
				'            "subscription_item": "si_RzDm1mHU3jd1KD",' +
				'            "tax_amounts": [' +
				'            ],' +
				'            "tax_rates": [' +
				'            ],' +
				'            "taxes": [' +
				'            ],' +
				'            "type": "subscription",' +
				'            "unit_amount_excluding_tax": "2050"' +
				'          }' +
				'        ],' +
				'        "has_more": false,' +
				'        "total_count": 1,' +
				'        "url": "/v1/invoices/in_1R5FKzCsC2AzqBfwD4TtcyUl/lines"' +
				'      },' +
				'      "livemode": false,' +
				'      "metadata": {' +
				'      },' +
				'      "next_payment_attempt": null,' +
				'      "number": "3D91EEBB-0001",' +
				'      "on_behalf_of": null,' +
				'      "paid": true,' +
				'      "paid_out_of_band": false,' +
				'      "parent": {' +
				'        "quote_details": null,' +
				'        "subscription_details": {' +
				'          "metadata": {' +
				'            "isTicket": "true"' +
				'          },' +
				'          "pause_collection": null,' +
				'          "subscription": "sub_1R5FKzCsC2AzqBfwgBuO9Gf7"' +
				'        },' +
				'        "type": "subscription_details"' +
				'      },' +
				'      "payment_intent": "pi_3R5FL0CsC2AzqBfw1zlkxSQU",' +
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
				'      "period_end": 1742601053,' +
				'      "period_start": 1742601053,' +
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
				'        "finalized_at": 1742601053,' +
				'        "marked_uncollectible_at": null,' +
				'        "paid_at": 1742601056,' +
				'        "voided_at": null' +
				'      },' +
				'      "subscription": "sub_1R5FKzCsC2AzqBfwgBuO9Gf7",' +
				'      "subscription_details": {' +
				'        "metadata": {' +
				'          "isTicket": "true"' +
				'        }' +
				'      },' +
				'      "subtotal": 6150,' +
				'      "subtotal_excluding_tax": 6150,' +
				'      "tax": null,' +
				'      "test_clock": null,' +
				'      "total": 6150,' +
				'      "total_discount_amounts": [' +
				'      ],' +
				'      "total_excluding_tax": 6150,' +
				'      "total_pretax_credit_amounts": [' +
				'      ],' +
				'      "total_tax_amounts": [' +
				'      ],' +
				'      "total_taxes": [' +
				'      ],' +
				'      "transfer_data": null,' +
				'      "webhooks_delivered_at": 1742601053' +
				'    }' +
				'  },' +
				'  "livemode": false,' +
				'  "pending_webhooks": 1,' +
				'  "request": {' +
				'    "id": null,' +
				'    "idempotency_key": "68d61219-5d69-4a99-9214-5a66315edda5"' +
				'  },' +
				'  "type": "invoice.payment_succeeded"' +
				'}'
		);
	}
}
