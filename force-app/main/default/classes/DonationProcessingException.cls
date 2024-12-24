public class DonationProcessingException extends Exception {
	public String customMessage;
	public Exception customCause;

	// Custom method to initialize message and cause
	public DonationProcessingException initialize(String message, Exception cause) {
		this.customMessage = message;
		this.customCause = cause;
		return this;
	}

	public DonationProcessingException initialize(String message) {
		this.customMessage = message;
		return this;
	}

	// Method to get the custom message
	public String getCustomMessage() {
		return customMessage;
	}

	// Method to get the custom cause
	public Exception getCustomCause() {
		return customCause;
	}
}
