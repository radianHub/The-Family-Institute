/**
 * @Class Name     : HttpResponseFactory
 * @Class Purpose  : SERVES AS DATA FACTORY FOR ALL YOUR HTTP RESPONSES
 * @Author         : Zachary Csotya
 * @Developed On   : 10/28/2023
 * @Last Modified  : 03/21/2025
 **/
@isTest
public with sharing class HttpResponseFactory {
	/**
	 * @description : CREATES AND RETURNS AN HTTP RESPONSE
	 * @author Zachary Csotya | 10/28/2023
	 * @param Integer code
	 * @param String status
	 * @param String body
	 * @return HttpResponse
	 **/
	public static HttpResponse createHttpResponse(Integer code, String status, String body) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(body);
		res.setStatus(status);
		res.setStatusCode(code);

		return res;
	}

	public static HttpResponse lineItemFailure() {
		String body =
			'{' +
			'    "error": {' +
			'        "code": "resource_missing",' +
			'        "doc_url": "https://stripe.com/docs/error-codes/resource-missing",' +
			'        "message": "No such checkout session: \'test\'",' +
			'        "param": "session",' +
			'        "request_log_url": "https://dashboard.stripe.com/test/logs/req_2s4iwPrlGwdD44?t=1742593639",' +
			'        "type": "invalid_request_error"' +
			'    }' +
			'}';

		return createHttpResponse(404, 'Not Found', body);
	}

	public static HttpResponse lineItemSuccess() {
		String body =
			'{' +
			'    "object": "list",' +
			'    "data": [' +
			'        {' +
			'            "id": "li_1R5AQZCsC2AzqBfw4t5aRqxA",' +
			'            "object": "item",' +
			'            "amount_discount": 0,' +
			'            "amount_subtotal": 12300,' +
			'            "amount_tax": 0,' +
			'            "amount_total": 12300,' +
			'            "currency": "usd",' +
			'            "description": "Registration(s): Test Event",' +
			'            "price": {' +
			'                "id": "price_1R5AQZCsC2AzqBfwlqtaYNRQ",' +
			'                "object": "price",' +
			'                "active": false,' +
			'                "billing_scheme": "per_unit",' +
			'                "created": 1742582179,' +
			'                "currency": "usd",' +
			'                "custom_unit_amount": null,' +
			'                "livemode": false,' +
			'                "lookup_key": null,' +
			'                "metadata": {},' +
			'                "nickname": null,' +
			'                "product": "prod_RwF614tzzCNI8d",' +
			'                "recurring": null,' +
			'                "tax_behavior": "unspecified",' +
			'                "tiers_mode": null,' +
			'                "transform_quantity": null,' +
			'                "type": "one_time",' +
			'                "unit_amount": 12300,' +
			'                "unit_amount_decimal": "12300"' +
			'            },' +
			'            "quantity": 1' +
			'        }' +
			'    ],' +
			'    "has_more": false,' +
			'    "url": "/v1/checkout/sessions/cs_test_a1fCSaX1yvRKgChgIDS1YQvreztdlKpzQpYXDR7BbUtBVDZHsHPJcBVT1N/line_items"' +
			'}';

		return createHttpResponse(200, 'OK', body);
	}
}
