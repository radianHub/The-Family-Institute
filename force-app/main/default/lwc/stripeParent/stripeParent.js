import { LightningElement, api } from 'lwc';

export default class StripeParent extends LightningElement {
	static renderMode = 'light';
	showDonation = true;
	@api headerColor;
	@api headerTextColor;
	@api publicApiKey;

	hideElement(e) {
		this.showDonation = !e.detail;
	}
}