/**
 * @Class Name     : HttpResponseMatchers
 * @Class Purpose  : HOUSES ALL OF THE RESPONSE MATCHING CLASSES (1 CLASS PER RESPONSE)
 * @Author         : Zachary Csotya
 * @Developed On   : 10/28/2023
 * @Last Modified  : 03/21/2025
 **/
@isTest
public with sharing class HttpResponseMatchers {
	public class SessionLineItemMatcher implements HttpMatchingStrategy {
		public HttpResponse matchResponse(HttpRequest req, Map<String, HttpResponse> responseStore, Boolean isSuccess) {
			if (req.getEndpoint().contains('line_items')) {
				return isSuccess ? responseStore.get('lineItemSuccess') : responseStore.get('lineItemFailure');
			}
			return null;
		}
	}
}
