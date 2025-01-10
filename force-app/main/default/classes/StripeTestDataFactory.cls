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
}
