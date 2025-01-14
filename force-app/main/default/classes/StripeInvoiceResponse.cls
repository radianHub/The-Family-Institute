public class StripeInvoiceResponse {
    public String id;
    public String objectz;
    public String api_version;
    public Long created;
	public cls_data data;
    public Boolean livemode;
    public Integer pending_webhooks;
    public String type;
    public cls_request request;

    public class cls_data {
        public cls_object objectz;
    }
	public class cls_object {
		public String id;	//in_1PCAUVCsC2AzqBfwOUaEPesI
		public String objectz;	//invoice
		public String account_country;	//US
		public String account_name;	//Zachary Csotya
		public cls_account_tax_ids account_tax_ids;
		public Integer amount_due;	//500
		public Integer amount_paid;	//500
		public Integer amount_remaining;	//0
		public Integer amount_shipping;	//0
		public cls_application application;
		public cls_application_fee_amount application_fee_amount;
		public Integer attempt_count;	//1
		public boolean attempted;
		public boolean auto_advance;
		public cls_automatic_tax automatic_tax;
		public String billing_reason;	//subscription_cycle
		public String charge;	//ch_3PCAUqCsC2AzqBfw15Tf4sED
		public String collection_method;	//charge_automatically
		public Integer created;	//1715907117
		public String currencyz;	//usd
		public cls_custom_fields custom_fields;
		public String customer;	//cus_Q2EpwG9r6OoH4E
		public cls_customer_address customer_address;
		public String customer_email;	//zachary.csotya@radianhub.com
		public String customer_name;	//Zac Test
		public String customer_phone;	//+18055981583
		public cls_customer_shipping customer_shipping;
		public String customer_tax_exempt;	//none
		public cls_customer_tax_ids[] customer_tax_ids;
		public cls_default_payment_method default_payment_method;
		public cls_default_source default_source;
		public cls_default_tax_rates[] default_tax_rates;
		public cls_description description;
		public cls_discount discount;
		public cls_discounts[] discounts;
		public cls_due_date due_date;
		public Integer effective_at;	//1715907600
		public Integer ending_balance;	//0
		public cls_footer footer;
		public cls_from_invoice from_invoice;
		public String hosted_invoice_url;	//https://invoice.stripe.com/i/acct_1P9aDTCsC2AzqBfw/test_YWNjdF8xUDlhRFRDc0MyQXpxQmZ3LF9RMkV5VlQwdER3bURxRWFxa3ZMUG9kbjdxaVJYclhVLDEwNTIzODg3MQ020031vVyqHJ?s=ap
		public String invoice_pdf;	//https://pay.stripe.com/invoice/acct_1P9aDTCsC2AzqBfw/test_YWNjdF8xUDlhRFRDc0MyQXpxQmZ3LF9RMkV5VlQwdER3bURxRWFxa3ZMUG9kbjdxaVJYclhVLDEwNTIzODg3MQ020031vVyqHJ/pdf?s=ap
		public cls_issuer issuer;
		public cls_last_finalization_error last_finalization_error;
		public cls_latest_revision latest_revision;
		public cls_lines lines;
		public boolean livemode;
		public cls_metadata metadata;
		public cls_next_payment_attempt next_payment_attempt;
		public String inv_number;	//68380CF3-0002
		public cls_on_behalf_of on_behalf_of;
		public boolean paid;
		public boolean paid_out_of_band;
		public String payment_intent;	//pi_3PCAUqCsC2AzqBfw18CzFI5k
		public cls_payment_settings payment_settings;
		public Integer period_end;	//1715907117
		public Integer period_start;	//1714697517
		public Integer post_payment_credit_notes_amount;	//0
		public Integer pre_payment_credit_notes_amount;	//0
		public cls_quote quote;
		public cls_receipt_number receipt_number;
		public cls_rendering rendering;
		public cls_shipping_cost shipping_cost;
		public cls_shipping_details shipping_details;
		public Integer starting_balance;	//0
		public cls_statement_descriptor statement_descriptor;
		public String status;	//paid
		public cls_status_transitions status_transitions;
		public String subscription;	//sub_1PCALxCsC2AzqBfwEtNY9vER
		public cls_subscription_details subscription_details;
		public Integer subtotal;	//500
		public Integer subtotal_excluding_tax;	//500
		public cls_tax tax;
		public String test_clock;	//clock_1PCAUUCsC2AzqBfwVdA6Pybu
		public Integer total;	//500
		public cls_total_discount_amounts[] total_discount_amounts;
		public Integer total_excluding_tax;	//500
		public cls_total_tax_amounts[] total_tax_amounts;
		public cls_transfer_data transfer_data;
		public Integer webhooks_delivered_at;	//1715907117
	}
	public class cls_account_tax_ids {
	}
	public class cls_application {
	}
	public class cls_application_fee_amount {
	}
	public class cls_automatic_tax {
		public boolean enabled;
		public cls_liability liability;
		public cls_status status;
	}
	public class cls_liability {
	}
	public class cls_status {
	}
	public class cls_custom_fields {
	}
	public class cls_customer_address {
		public String city;	//San Francisco
		public String country;	//US
		public String line1;	//123 Market Street
		public cls_line2 line2;
		public String postal_code;	//94105
		public String state;	//CA
	}
	public class cls_line2 {
	}
	public class cls_customer_shipping {
	}
	public class cls_customer_tax_ids {
	}
	public class cls_default_payment_method {
	}
	public class cls_default_source {
	}
	public class cls_default_tax_rates {
	}
	public class cls_description {
	}
	public class cls_discount {
	}
	public class cls_discounts {
	}
	public class cls_due_date {
	}
	public class cls_footer {
	}
	public class cls_from_invoice {
	}
	public class cls_issuer {
		public String type;	//self
	}
	public class cls_last_finalization_error {
	}
	public class cls_latest_revision {
	}
	public class cls_lines {
		public String objectz;	//list
		public cls_data2[] data;
		public boolean has_more;
		public Integer total_count;	//1
		public String url;	///v1/invoices/in_1PCAUVCsC2AzqBfwOUaEPesI/lines
	}
	public class cls_data2 {
		public String id;	//il_1PHF1dCsC2AzqBfwcaTHHcuF
		public String objectz;	//line_item
		public Integer amount;	//500
		public Integer amount_excluding_tax;	//500
		public String currencyz;	//usd
		public String description;	//1 × Donation (at $5.00 / every 2 weeks)
		public cls_discount_amounts[] discount_amounts;
		public boolean discountable;
		public cls_discounts[] discounts;
		public String invoice;	//in_1PCAUVCsC2AzqBfwOUaEPesI
		public boolean livemode;
		public cls_metadata metadata;
		public cls_period period;
		public cls_plan plan;
		public cls_price price;
		public boolean proration;
		public cls_proration_details proration_details;
		public Integer quantity;	//1
		public String subscription;	//sub_1PCALxCsC2AzqBfwEtNY9vER
		public String subscription_item;	//si_Q2Ep1NCLRQLJRv
		public cls_tax_amounts[] tax_amounts;
		public cls_tax_rates[] tax_rates;
		public String type;	//subscription
		public String unit_amount_excluding_tax;	//500
	}
	public class cls_discount_amounts {
	}
	public class cls_metadata {
	}
	public class cls_period {
		public Integer endz;	//1717116717
		public Integer start;	//1715907117
	}
	public class cls_plan {
		public String id;	//price_1PCALtCsC2AzqBfw9bLxQple
		public String objectz;	//plan
		public boolean active;
		public cls_aggregate_usage aggregate_usage;
		public Integer amount;	//500
		public String amount_decimal;	//500
		public String billing_scheme;	//per_unit
		public Integer created;	//1714697513
		public String currencyz;	//usd
		public String interval;	//week
		public Integer interval_count;	//2
		public boolean livemode;
		public cls_metadata metadata;
		public cls_meter meter;
		public cls_nickname nickname;
		public String product;	//prod_PzzlXgEIpNHnPS
		public cls_tiers_mode tiers_mode;
		public cls_transform_usage transform_usage;
		public cls_trial_period_days trial_period_days;
		public String usage_type;	//licensed
	}
	public class cls_aggregate_usage {
	}
	public class cls_meter {
	}
	public class cls_nickname {
	}
	public class cls_tiers_mode {
	}
	public class cls_transform_usage {
	}
	public class cls_trial_period_days {
	}
	public class cls_price {
		public String id;	//price_1PCALtCsC2AzqBfw9bLxQple
		public String objectz;	//price
		public boolean active;
		public String billing_scheme;	//per_unit
		public Integer created;	//1714697513
		public String currencyz;	//usd
		public cls_custom_unit_amount custom_unit_amount;
		public boolean livemode;
		public cls_lookup_key lookup_key;
		public cls_metadata metadata;
		public cls_nickname nickname;
		public String product;	//prod_PzzlXgEIpNHnPS
		public cls_recurring recurring;
		public String tax_behavior;	//unspecified
		public cls_tiers_mode tiers_mode;
		public cls_transform_quantity transform_quantity;
		public String type;	//recurring
		public Integer unit_amount;	//500
		public String unit_amount_decimal;	//500
	}
	public class cls_custom_unit_amount {
	}
	public class cls_lookup_key {
	}
	public class cls_recurring {
		public cls_aggregate_usage aggregate_usage;
		public String interval;	//week
		public Integer interval_count;	//2
		public cls_meter meter;
		public cls_trial_period_days trial_period_days;
		public String usage_type;	//licensed
	}
	public class cls_transform_quantity {
	}
	public class cls_proration_details {
		public cls_credited_items credited_items;
	}
	public class cls_credited_items {
	}
	public class cls_tax_amounts {
	}
	public class cls_tax_rates {
	}
	public class cls_next_payment_attempt {
	}
	public class cls_on_behalf_of {
	}
	public class cls_payment_settings {
		public cls_default_mandate default_mandate;
		public cls_payment_method_options payment_method_options;
		public cls_payment_method_types payment_method_types;
	}
	public class cls_default_mandate {
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
	}
	public class cls_bancontact {
	}
	public class cls_card {
		public String request_three_d_secure;	//automatic
	}
	public class cls_customer_balance {
	}
	public class cls_konbini {
	}
	public class cls_sepa_debit {
	}
	public class cls_us_bank_account {
	}
	public class cls_payment_method_types {
	}
	public class cls_quote {
	}
	public class cls_receipt_number {
	}
	public class cls_rendering {
	}
	public class cls_shipping_cost {
	}
	public class cls_shipping_details {
	}
	public class cls_statement_descriptor {
	}
	public class cls_status_transitions {
		public Integer finalized_at;	//1715907600
		public cls_marked_uncollectible_at marked_uncollectible_at;
		public Integer paid_at;	//1715907600
		public cls_voided_at voided_at;
	}
	public class cls_marked_uncollectible_at {
	}
	public class cls_voided_at {
	}
	public class cls_subscription_details {
		public cls_metadata metadata;
	}
	public class cls_tax {
	}
	public class cls_total_discount_amounts {
	}
	public class cls_total_tax_amounts {
	}
	public class cls_transfer_data {
	}
    public class cls_request {
        public String id;
        public String indempotency_key;
    }
}