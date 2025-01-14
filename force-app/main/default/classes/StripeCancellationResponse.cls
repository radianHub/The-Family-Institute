public class StripeCancellationResponse {
	public String id; //evt_1QflFnCsC2AzqBfwFmInWYqf
	public String objectz; //event
	public String api_version; //2024-04-10
	public Integer created; //1736527211
	public cls_data data;
	public boolean livemode;
	public Integer pending_webhooks; //1
	public cls_request request;
	public String type; //customer.subscription.deleted
	public class cls_data {
		public cls_object objectz;
	}
	public class cls_object {
		public String id; //sub_1Qbaf6CsC2AzqBfwDvf2QQBF
		public String objectz; //subscription
		public String application;
		public Decimal application_fee_percent;
		public cls_automatic_tax automatic_tax;
		public Integer billing_cycle_anchor; //1735533184
		public cls_billing_cycle_anchor_config billing_cycle_anchor_config;
		public cls_billing_thresholds billing_thresholds;
		public Integer cancel_at;
		public Boolean cancel_at_period_end;
		public Integer canceled_at; //1736527210
		public cls_cancellation_details cancellation_details;
		public String collection_method; //charge_automatically
		public Integer created; //1735533184
		public String currencyz; //usd
		public Integer current_period_end; //1738211584
		public Integer current_period_start; //1735533184
		public String customer; //cus_RUZoaop4dKe766
		public Integer days_until_due;
		public String default_payment_method; //pm_1Qbaf5CsC2AzqBfwxyf6JFlR
		public String default_source;
		public cls_default_tax_rates[] default_tax_rates;
		public String description;
		public cls_discount discount;
		public String[] discounts;
		public Integer ended_at; //1736527210
		public cls_invoice_settings invoice_settings;
		public cls_items items;
		public String latest_invoice; //in_1Qbaf6CsC2AzqBfw1jFhmvYj
		public boolean livemode;
		public cls_metadata metadata;
		public Integer next_pending_invoice_item_invoice;
		public String on_behalf_of;
		public cls_pause_collection pause_collection;
		public cls_payment_settings payment_settings;
		public cls_pending_invoice_item_interval pending_invoice_item_interval;
		public String pending_setup_intent;
		public cls_pending_update pending_update;
		public cls_plan plan;
		public Integer quantity; //1
		public String schedule;
		public Integer start_date; //1735533184
		public String status; //canceled
		public String test_clock;
		public cls_transfer_data transfer_data;
		public Integer trial_end;
		public cls_trial_settings trial_settings;
		public Integer trial_start;
	}
	public class cls_automatic_tax {
		public String disabled_reason;
		public boolean enabled;
		public cls_liability liability;
	}
	public class cls_liability {
		public String account;
		public String type;
	}
	public class cls_billing_cycle_anchor_config {
		public Integer day_of_month;
		public Integer hour;
		public Integer minute;
		public Integer month;
		public Integer second;
	}
	public class cls_billing_thresholds {
		public Integer amount_gte;
		public Boolean reset_billing_cycle_anchor;
		public Integer usage_gte;
	}
	public class cls_cancellation_details {
		public String comment;
		public String feedback;
		public String reason; //cancellation_requested
	}
	public class cls_default_tax_rates {
		public String id;
		public String objectz;
		public Boolean active;
		public String country;
		public Integer created;
		public String description;
		public String display_name;
		public Decimal effective_percentage;
		public cls_flat_amount flat_amount;
		public Boolean inclusive;
		public String jurisdiction;
		public String jurisdiction_level;
		public Boolean livemode;
		public cls_metadata metadata;
		public Decimal percentage;
		public String rate_type;
		public String state;
		public string tax_type;
	}
	public class cls_flat_amount {
		public Integer amount;
		public String currencyz;
	}
	public class cls_discount {
		public String id;
		public String objectz;
		public String checkout_session;
		public cls_coupon coupon;
		public String customer;
		public Integer endz;
		public String invoice;
		public String invoice_item;
		public String promotion_code;
		public Integer start;
		public String subscription;
		public String subscription_item;
	}
	public class cls_coupon {
		public String id;
		public String objectz;
		public Integer amount_off;
		public cls_applies_to applies_to;
		public Integer created;
		public String currencyz;
		public cls_currency_options currency_options;
		public String duration;
		public Integer duration_in_months;
		public Boolean livemode;
		public Integer max_redemptions;
		public cls_metadata metadata;
		public String name;
		public Decimal percent_off;
		public Integer redeem_by;
		public Integer times_redeemed;
		public Boolean valid;
	}
	public class cls_applies_to {
		public String[] products;
	}
	public class cls_currency_options {
		public Integer amount_off;
	}
	public class cls_invoice_settings {
		public String[] account_tax_ids;
		public cls_issuer issuer;
	}
	public class cls_issuer {
		public String type;
		public String account;
	}
	public class cls_items {
		public String objectz; //list
		public cls_item_data[] data;
		public boolean has_more;
		public Integer total_count; //1
		public String url; ///v1/subscription_items?subscription=sub_1Qbaf6CsC2AzqBfwDvf2QQBF
	}
	public class cls_item_data {
		public String id;
		public String objectz;
		public cls_billing_thresholds billing_thresholds;
		public Integer created;
		public String[] discounts;
		public cls_metadata metadata;
		public cls_price price;
		public Integer quantity;
		public String subscription;
		public cls_tax_rates[] tax_rates;
	}
	public class cls_price {
		public String id; //price_1Qbaf2CsC2AzqBfwgpi8KZfs
		public String objectz; //price
		public boolean active;
		public String billing_scheme; //per_unit
		public Integer created; //1735533180
		public String currencyz; //usd
		public cls_custom_unit_amount custom_unit_amount;
		public boolean livemode;
		public String lookup_key;
		public cls_metadata metadata;
		public String nickname;
		public String product; //prod_PzzlXgEIpNHnPS
		public cls_recurring recurring;
		public String tax_behavior; //unspecified
		public cls_tiers tiers;
		public String tiers_mode;
		public cls_transform_quantity transform_quantity;
		public String type; //recurring
		public Integer unit_amount; //500
		public String unit_amount_decimal; //500
	}
	public class cls_custom_unit_amount {
		public Integer maximum;
		public Integer minimum;
		public Integer preset;
	}
	public class cls_metadata {
	}
	public class cls_plan {
		public String id; //price_1Qbaf2CsC2AzqBfwgpi8KZfs
		public String objectz; //plan
		public boolean active;
		public String aggregate_usage;
		public Integer amount; //500
		public String amount_decimal; //500
		public String billing_scheme; //per_unit
		public Integer created; //1735533180
		public String currencyz; //usd
		public String interval; //month
		public Integer interval_count; //1
		public boolean livemode;
		public cls_metadata metadata;
		public String meter;
		public String nickname;
		public String product; //prod_PzzlXgEIpNHnPS
		public String tiers_mode;
		public cls_transform_usage transform_usage;
		public Integer trial_period_days;
		public String usage_type; //licensed
	}
	public class cls_tiers {
		public Integer flat_amount;
		public String flat_amount_decimal;
		public Integer unit_amount;
		public String unit_amount_decimal;
		public Integer up_to;
	}
	public class cls_transform_usage {
		public Integer divide_by;
		public String round;
	}
	public class cls_recurring {
		public String aggregate_usage;
		public String interval; //month
		public Integer interval_count; //1
		public String meter;
		public Integer trial_period_days;
		public String usage_type; //licensed
	}
	public class cls_transform_quantity {
		public Integer divide_by;
		public String round;
	}
	public class cls_tax_rates {
		public String id;
		public String objectz;
		public Boolean active;
		public String country;
		public Integer created;
		public String description;
		public String display_name;
		public Decimal effective_percentage;
		public cls_flat_amount flat_amount;
		public Boolean inclusive;
		public String jurisdiction;
		public String jurisdiction_level;
		public Boolean livemode;
		public cls_metadata metadata;
		public Decimal percentage;
		public String rate_type;
		public String state;
		public String tax_type;
	}
	public class cls_pause_collection {
		public String behavior;
		public Integer resumes_at;
	}
	public class cls_payment_settings {
		public cls_payment_method_options payment_method_options;
		public String[] payment_method_types;
		public String save_default_payment_method; //off
	}
	public class cls_payment_method_options {
		public cls_acss_debit acss_debit;
		public cls_bancontact bancontact;
		public cls_card card;
		public cls_customer_balance customer_balance;
		public cls_konbini konbini;
		public cls_sepa_debit sepa_debit;
		public cls_us_bank_account us_bank_account;
	}
	public class cls_acss_debit {
		public cls_mandate_options mandate_options;
		public String verification_method;
	}
	public class cls_mandate_options {
		public String transaction_type;
		public Integer amount;
		public String amount_type;
		public String description;
	}
	public class cls_bancontact {
		public String preferred_language;
	}
	public class cls_card {
		public cls_mandate_options mandate_options;
		public String network;
		public String request_three_d_secure; //automatic
	}
	public class cls_customer_balance {
		public cls_bank_transfer bank_transfer;
		public String funding_type;
	}
	public class cls_bank_transfer {
		public cls_eu_bank_transfer eu_bank_transfer;
		public String type;
	}
	public class cls_eu_bank_transfer {
		public String country;
	}
	public class cls_konbini {
	}
	public class cls_sepa_debit {
	}
	public class cls_us_bank_account {
		public cls_financial_connections financial_connections;
		public String verification_method;
	}
	public class cls_financial_connections {
		public cls_filters filters;
		public String[] permissions;
		public String[] prefetch;
		public String verification_method;
	}
	public class cls_filters {
		public String[] account_subcategories;
	}
	public class cls_pending_invoice_item_interval {
		public String interval;
		public Integer interval_count;
	}
	public class cls_pending_update {
		public Integer billing_cycle_anchor;
		public Integer expires_at;
		public cls_subscription_items subscription_items;
		public Integer trial_end;
		public Boolean trial_from_plan;
	}
	public class cls_subscription_items {
		public String id;
		public String objectz;
		public cls_billing_thresholds billing_thresholds;
		public Integer created;
		public String[] discounts;
		public cls_metadata metadata;
		public cls_price price;
		public Integer quantity;
		public String subscription;
		public cls_tax_rates[] tax_rates;
	}
	public class cls_transfer_data {
		public Decimal amount_percent;
		public String destination;
	}
	public class cls_trial_settings {
		public cls_end_behavior end_behavior;
	}
	public class cls_end_behavior {
		public String missing_payment_method; //create_invoice
	}
	public class cls_request {
		public String id; //req_tDzPkUf7JnQ4DA
		public String idempotency_key;
	}

	// static testMethod void testParse() {
	// 	String json =
	// 		'{' +
	// 		'  "id": "evt_1QflFnCsC2AzqBfwFmInWYqf",' +
	// 		'  "object": "event",' +
	// 		'  "api_version": "2024-04-10",' +
	// 		'  "created": 1736527211,' +
	// 		'  "data": {' +
	// 		'    "object": {' +
	// 		'      "id": "sub_1Qbaf6CsC2AzqBfwDvf2QQBF",' +
	// 		'      "object": "subscription",' +
	// 		'      "application": null,' +
	// 		'      "application_fee_percent": null,' +
	// 		'      "automatic_tax": {' +
	// 		'        "disabled_reason": null,' +
	// 		'        "enabled": false,' +
	// 		'        "liability": null' +
	// 		'      },' +
	// 		'      "billing_cycle_anchor": 1735533184,' +
	// 		'      "billing_cycle_anchor_config": null,' +
	// 		'      "billing_thresholds": null,' +
	// 		'      "cancel_at": null,' +
	// 		'      "cancel_at_period_end": false,' +
	// 		'      "canceled_at": 1736527210,' +
	// 		'      "cancellation_details": {' +
	// 		'        "comment": null,' +
	// 		'        "feedback": null,' +
	// 		'        "reason": "cancellation_requested"' +
	// 		'      },' +
	// 		'      "collection_method": "charge_automatically",' +
	// 		'      "created": 1735533184,' +
	// 		'      "currency": "usd",' +
	// 		'      "current_period_end": 1738211584,' +
	// 		'      "current_period_start": 1735533184,' +
	// 		'      "customer": "cus_RUZoaop4dKe766",' +
	// 		'      "days_until_due": null,' +
	// 		'      "default_payment_method": "pm_1Qbaf5CsC2AzqBfwxyf6JFlR",' +
	// 		'      "default_source": null,' +
	// 		'      "default_tax_rates": [' +
	// 		'      ],' +
	// 		'      "description": null,' +
	// 		'      "discount": null,' +
	// 		'      "discounts": [' +
	// 		'      ],' +
	// 		'      "ended_at": 1736527210,' +
	// 		'      "invoice_settings": {' +
	// 		'        "account_tax_ids": null,' +
	// 		'        "issuer": {' +
	// 		'          "type": "self"' +
	// 		'        }' +
	// 		'      },' +
	// 		'      "items": {' +
	// 		'        "object": "list",' +
	// 		'        "data": [' +
	// 		'          {' +
	// 		'            "id": "si_RUZoGIhJ05JmOi",' +
	// 		'            "object": "subscription_item",' +
	// 		'            "billing_thresholds": null,' +
	// 		'            "created": 1735533185,' +
	// 		'            "discounts": [' +
	// 		'            ],' +
	// 		'            "metadata": {' +
	// 		'            },' +
	// 		'            "plan": {' +
	// 		'              "id": "price_1Qbaf2CsC2AzqBfwgpi8KZfs",' +
	// 		'              "object": "plan",' +
	// 		'              "active": false,' +
	// 		'              "aggregate_usage": null,' +
	// 		'              "amount": 500,' +
	// 		'              "amount_decimal": "500",' +
	// 		'              "billing_scheme": "per_unit",' +
	// 		'              "created": 1735533180,' +
	// 		'              "currency": "usd",' +
	// 		'              "interval": "month",' +
	// 		'              "interval_count": 1,' +
	// 		'              "livemode": false,' +
	// 		'              "metadata": {' +
	// 		'              },' +
	// 		'              "meter": null,' +
	// 		'              "nickname": null,' +
	// 		'              "product": "prod_PzzlXgEIpNHnPS",' +
	// 		'              "tiers_mode": null,' +
	// 		'              "transform_usage": null,' +
	// 		'              "trial_period_days": null,' +
	// 		'              "usage_type": "licensed"' +
	// 		'            },' +
	// 		'            "price": {' +
	// 		'              "id": "price_1Qbaf2CsC2AzqBfwgpi8KZfs",' +
	// 		'              "object": "price",' +
	// 		'              "active": false,' +
	// 		'              "billing_scheme": "per_unit",' +
	// 		'              "created": 1735533180,' +
	// 		'              "currency": "usd",' +
	// 		'              "custom_unit_amount": null,' +
	// 		'              "livemode": false,' +
	// 		'              "lookup_key": null,' +
	// 		'              "metadata": {' +
	// 		'              },' +
	// 		'              "nickname": null,' +
	// 		'              "product": "prod_PzzlXgEIpNHnPS",' +
	// 		'              "recurring": {' +
	// 		'                "aggregate_usage": null,' +
	// 		'                "interval": "month",' +
	// 		'                "interval_count": 1,' +
	// 		'                "meter": null,' +
	// 		'                "trial_period_days": null,' +
	// 		'                "usage_type": "licensed"' +
	// 		'              },' +
	// 		'              "tax_behavior": "unspecified",' +
	// 		'              "tiers_mode": null,' +
	// 		'              "transform_quantity": null,' +
	// 		'              "type": "recurring",' +
	// 		'              "unit_amount": 500,' +
	// 		'              "unit_amount_decimal": "500"' +
	// 		'            },' +
	// 		'            "quantity": 1,' +
	// 		'            "subscription": "sub_1Qbaf6CsC2AzqBfwDvf2QQBF",' +
	// 		'            "tax_rates": [' +
	// 		'            ]' +
	// 		'          }' +
	// 		'        ],' +
	// 		'        "has_more": false,' +
	// 		'        "total_count": 1,' +
	// 		'        "url": "/v1/subscription_items?subscription=sub_1Qbaf6CsC2AzqBfwDvf2QQBF"' +
	// 		'      },' +
	// 		'      "latest_invoice": "in_1Qbaf6CsC2AzqBfw1jFhmvYj",' +
	// 		'      "livemode": false,' +
	// 		'      "metadata": {' +
	// 		'      },' +
	// 		'      "next_pending_invoice_item_invoice": null,' +
	// 		'      "on_behalf_of": null,' +
	// 		'      "pause_collection": null,' +
	// 		'      "payment_settings": {' +
	// 		'        "payment_method_options": {' +
	// 		'          "acss_debit": null,' +
	// 		'          "bancontact": null,' +
	// 		'          "card": {' +
	// 		'            "network": null,' +
	// 		'            "request_three_d_secure": "automatic"' +
	// 		'          },' +
	// 		'          "customer_balance": null,' +
	// 		'          "konbini": null,' +
	// 		'          "sepa_debit": null,' +
	// 		'          "us_bank_account": null' +
	// 		'        },' +
	// 		'        "payment_method_types": null,' +
	// 		'        "save_default_payment_method": "off"' +
	// 		'      },' +
	// 		'      "pending_invoice_item_interval": null,' +
	// 		'      "pending_setup_intent": null,' +
	// 		'      "pending_update": null,' +
	// 		'      "plan": {' +
	// 		'        "id": "price_1Qbaf2CsC2AzqBfwgpi8KZfs",' +
	// 		'        "object": "plan",' +
	// 		'        "active": false,' +
	// 		'        "aggregate_usage": null,' +
	// 		'        "amount": 500,' +
	// 		'        "amount_decimal": "500",' +
	// 		'        "billing_scheme": "per_unit",' +
	// 		'        "created": 1735533180,' +
	// 		'        "currency": "usd",' +
	// 		'        "interval": "month",' +
	// 		'        "interval_count": 1,' +
	// 		'        "livemode": false,' +
	// 		'        "metadata": {' +
	// 		'        },' +
	// 		'        "meter": null,' +
	// 		'        "nickname": null,' +
	// 		'        "product": "prod_PzzlXgEIpNHnPS",' +
	// 		'        "tiers_mode": null,' +
	// 		'        "transform_usage": null,' +
	// 		'        "trial_period_days": null,' +
	// 		'        "usage_type": "licensed"' +
	// 		'      },' +
	// 		'      "quantity": 1,' +
	// 		'      "schedule": null,' +
	// 		'      "start_date": 1735533184,' +
	// 		'      "status": "canceled",' +
	// 		'      "test_clock": null,' +
	// 		'      "transfer_data": null,' +
	// 		'      "trial_end": null,' +
	// 		'      "trial_settings": {' +
	// 		'        "end_behavior": {' +
	// 		'          "missing_payment_method": "create_invoice"' +
	// 		'        }' +
	// 		'      },' +
	// 		'      "trial_start": null' +
	// 		'    }' +
	// 		'  },' +
	// 		'  "livemode": false,' +
	// 		'  "pending_webhooks": 1,' +
	// 		'  "request": {' +
	// 		'    "id": "req_tDzPkUf7JnQ4DA",' +
	// 		'    "idempotency_key": null' +
	// 		'  },' +
	// 		'  "type": "customer.subscription.deleted"' +
	// 		'}';
	// }
}
