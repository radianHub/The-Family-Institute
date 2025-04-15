/**
 * @Class Name     : HttpMatchingStrategy
 * @Class Purpose  : PROVIDE A BLUEPRINT HTTP RESPONSE MATCHING
 * @Author         : Zachary Csotya
 * @Developed On   :
 * @Last Modified  : 03/21/2025
 **/
public interface HttpMatchingStrategy {
	HttpResponse matchResponse(HttpRequest req, Map<String, HttpResponse> responseStore, Boolean isSuccess);
}
