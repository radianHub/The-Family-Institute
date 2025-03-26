public class StripeResponse {
	public String id;
	public String objecta;
	public String api_version;
	public Integer created;
	public cls_data data;
	public boolean livemode;
	public Integer pending_webhooks;
	public cls_request request;
	public String type;

	public class cls_data {
		public cls_object objectz;
	}

	public class cls_object {
		public String id;
		public String objectz;
		public cls_after_expiration after_expiration;
		public Boolean allow_promotion_codes;
		public Integer amount_subtotal;
		public Integer amount_total;
		public cls_automatic_tax automatic_tax;
		public String billing_address_collection;
		public String cancel_url;
		public String client_reference_id;
		public String client_secret;
		public cls_consent consent;
		public cls_consent_collection consent_collection;
		public Long created;
		public String currencyz;
		public cls_currency_conversion currency_conversion;
		public cls_custom_fields[] custom_fields;
		public cls_custom_text custom_text;
		public String customer;
		public String customer_creation;
		public cls_customer_details customer_details;
		public String customer_email;
		public Long expires_at;
		public String invoice;
		public cls_invoice_creation invoice_creation;
		public boolean livemode;
		public String locale;
		public cls_metadata metadata;
		public String mode;
		public String payment_intent;
		public String payment_link;
		public String payment_method_collection;
		public cls_payment_method_configuration_details payment_method_configuration_details;
		public cls_payment_method_options payment_method_options;
		public String[] payment_method_types;
		public String payment_status;
		public cls_phone_number_collection phone_number_collection;
		public String recovered_from;
		public cls_saved_payment_method_options saved_payment_method_options;
		public String setup_intent;
		public cls_shipping_address_collection shipping_address_collection;
		public cls_shipping_cost shipping_cost;
		public cls_shipping_details shipping_details;
		public cls_shipping_options[] shipping_options;
		public String status;
		public String submit_type;
		public String subscription;
		public String success_url;
		public cls_total_details total_details;
		public String ui_mode;
		public String url;
	}

	public class cls_after_expiration {
		public cls_recovery recovery;
	}
	public class cls_recovery {
		public Boolean allow_promotion_codes;
		public Boolean enabled;
		public Long expires_at;
		public String url;
	}

	public class cls_automatic_tax {
		public boolean enabled;
		public cls_liability liability;
		public String status;
	}
	public class cls_liability {
		public String account;
		public String type;
	}

	public class cls_consent {
		public String promotions;
		public String terms_of_service;
	}

	public class cls_consent_collection {
		public cls_payment_method_reuse_agreement payment_method_reuse_agreement;
		public String promotions;
		public String terms_of_service;
	}
	public class cls_payment_method_reuse_agreement {
		public String position;
	}

	public class cls_currency_conversion {
		public Integer amount_subtotal;
		public Integer amount_total;
		public Decimal fx_rate;
		public String source_currency;
	}

	public class cls_custom_fields {
		public cls_dropdown dropdown;
		public String key;
		public cls_label label;
		public cls_numeric numeric;
		public Boolean optional;
		public cls_text text;
		public String type;
	}
	public class cls_dropdown {
		public String value;
		public cls_options options;
	}
	public class cls_options {
		public String label;
		public String value;
	}
	public class cls_label {
		public String custom;
		public String type;
	}
	public class cls_numeric {
		public Integer maximum_length;
		public Integer minimum_length;
		public String value;
	}
	public class cls_text {
		public Integer maximum_length;
		public Integer minimum_length;
		public String value;
	}

	public class cls_custom_text {
		public cls_after_submit after_submit;
		public cls_shipping_address shipping_address;
		public cls_submit submit;
		public cls_terms_of_service_acceptance terms_of_service_acceptance;
	}
	public class cls_after_submit {
		public String message;
	}
	public class cls_shipping_address {
		public String message;
	}
	public class cls_submit {
		public String message;
	}
	public class cls_terms_of_service_acceptance {
		public String message;
	}

	public class cls_customer_details {
		public cls_address address;
		public String email;
		public String name;
		public String phone;
		public String tax_exempt;
		public cls_tax_ids[] tax_ids;
	}
	public class cls_address {
		public String city;
		public String country;
		public String line1;
		public String line2;
		public String postal_code;
		public String state;
	}
	public class cls_tax_ids {
		public String type;
		public String value;
	}

	public class cls_invoice_creation {
		public boolean enabled;
		public cls_invoice_data invoice_data;
	}
	public class cls_invoice_data {
		public cls_account_tax_ids account_tax_ids;
		public cls_custom_invoice_fields custom_fields;
		public String description;
		public String footer;
		public cls_issuer issuer;
		public cls_metadata metadata;
		public cls_rendering_options rendering_options;
	}
	public class cls_account_tax_ids {
		public String[] account_tax_ids;
	}
	public class cls_custom_invoice_fields {
		public String name;
		public String value;
	}
	public class cls_issuer {
		public String account;
		public String type;
	}
	public class cls_metadata {
		public String honoree;
		public String organization;
		public String match;
		public String campaignId;
		public String oscId;
		public String recurrence;
		public String anonymous;
		public Boolean addFee;
		public Decimal coverFeeAmount;
		public Decimal processorFeeAmount;
		public String tributeType;
		public Integer intervalCount;
		public String giftType;
		public String type;
		public String payer;
		public Integer paymentLength;
	}
	public class cls_rendering_options {
		public String amount_tax_display;
	}

	public class cls_payment_method_configuration_details {
		public String id;
		public String parent;
	}

	public class cls_payment_method_options {
		public cls_card card;
	}
	public class cls_card {
		public String request_three_d_secure;
	}

	public class cls_phone_number_collection {
		public Boolean enabled;
	}

	public class cls_saved_payment_method_options {
		public String[] allow_redisplay_filters;
		public String payment_method_save;
	}

	public class cls_shipping_address_collection {
		public String[] allowed_countries;
	}

	public class cls_shipping_cost {
		public Integer amount_subtotal;
		public Integer amount_tax;
		public Integer amount_total;
		public String shipping_rate;
		public cls_taxes[] taxes;
	}
	public class cls_taxes {
	}

	public class cls_shipping_details {
	}

	public class cls_shipping_options {
	}

	public class cls_total_details {
		public Integer amount_discount;
		public Integer amount_shipping;
		public Integer amount_tax;
	}

	public class cls_request {
		public String id;
		public String idempotency_key;
	}

	public class cls_honoree {
		public Boolean isHonor;
		public String honorType;
		public honorData honoreeInfo;

		public cls_honoree parse(String json) {
			return (cls_honoree) System.JSON.deserialize(json, cls_honoree.class);
		}
	}

	public class honorData {
		public String FirstName;
		public String LastName;
		public String Street;
		public String City;
		public String State;
		public String Zip;
		public String Email;
		public String Phone;
		public String HonoreeDescription;
	}

	public class cls_recurrence {
		public Boolean isRecurring;
		public String interval;
		public Integer intervalCount;

		public cls_recurrence parse(String json) {
			return (cls_recurrence) System.JSON.deserialize(json, cls_recurrence.class);
		}
	}

	public class cls_organization {
		public Boolean isOrg;
		public OrgData orgInfo;

		public cls_organization parse(String json) {
			return (cls_organization) System.JSON.deserialize(json, cls_organization.class);
		}
	}

	public class OrgData {
		public String orgName;
		public String Street;
		public String City;
		public String State;
		public String Zip;
		public String Phone;
	}

	public class cls_employer {
		public Boolean isMatch;
		public EmployerData employerInfo;

		public cls_employer parse(String json) {
			return (cls_employer) System.JSON.deserialize(json, cls_employer.class);
		}
	}

	public class EmployerData {
		public String employerName;
	}

	public class cls_payer {
		public String firstName;
		public String lastName;
		public String email;
		public String phone;
		public String street;
		public String city;
		public String state;
		public String zip;

		public cls_payer parse(String json) {
			return (cls_payer) System.JSON.deserialize(json, cls_payer.class);
		}
	}
}
