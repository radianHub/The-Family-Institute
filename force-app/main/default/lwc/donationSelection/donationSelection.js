import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ToastContainer from 'lightning/toastContainer';

import ticketSelection from './ticketSelection.html';
import donationSelection from './donationSelection.html';
import successPage from './success.html';

import getDonationAmounts from '@salesforce/apex/DonationSelectionController.getDonationAmounts';
import getProcessingFee from '@salesforce/apex/DonationSelectionController.getProcessingFee';
import getAssociatedFunds from '@salesforce/apex/DonationSelectionController.getAssociatedFunds';
import getSettings from '@salesforce/apex/DonationSelectionController.getSettings';
import createTicketRecords from '@salesforce/apex/DonationSelectionController.createTicketRecords';
import getCampaign from '@salesforce/apex/DonationSelectionController.getCampaign';

export default class DonationSelection extends LightningElement {
	// PUBLIC PROPERTIES
	@api headerColor;
	@api headerTextColor;
	@api publicApiKey;
	@api callbackUrl;

	// COMPONENT SETTINGS
	settings;

	// SPECIFIC GIVING PROPERTIES
	funds;
	campaignId;
	oscId;

	// TICKET PROPERTIES
	campaign;
	ticketCount = 0;
	paymentLock = false;
	payments = false;
	payerData = {
		detail: {
			firstName: '',
			lastName: '',
			street: '',
			city: '',
			state: '',
			zip: '',
			email: '',
			phone: '',
		},
	};
	isRegistered = false;

	// GIVING PROPERTIES
	donationAmounts;
	donationAmt = 0;
	givingType;
	givingInterval;
	showFreq = false;
	recurFreq;

	// FEE PROPERTIES
	processingFee;
	addFee = false;

	// HONOREE/MEMORIAL PROPERTIES
	honorSelection;
	honor = false;
	honoree = {
		isHonor: this.honor,
		honoreeInfo: {},
	};

	// EMPLOYEE MATCHING PROPERTIES
	match = false;
	employer = {
		isMatch: this.match,
		employerInfo: {},
	};

	// ANONYMOUS PROPERTIES
	anonymous = false;

	// ORGANIZATION PROPERTIES
	organization = false;
	org = {
		isOrg: this.organization,
		orgInfo: {},
	};

	// INTEGRATION PROPERTIES
	stripe;
	isLoaded = false;

	// PROCESSING PROPERTIES
	isLoading = true;
	isSaving = false;

	// # LIFECYCLE HOOKS

	connectedCallback() {
		this.campaignId = this.currentPageReference.state.campaign;
		this.oscId = this.currentPageReference.state.osc;
		this.getProcessingFee();
		this.getSettings();
		this.getDonationAmounts();
		this.getAssociatedFunds(this.campaignId, this.oscId);
		setTimeout(() => {
			this.isLoading = false;
		}, 1500);
	}

	render() {
		if (this.campaign?.Type === 'Event' && Number(this.total) === 0 && this.isRegistered) {
			return successPage;
		}
		return this.campaign?.Type === 'Event' ? ticketSelection : donationSelection;
	}

	renderedCallback() {
		if (!this.isLoaded) {
			const script = document.createElement('script');
			script.src = 'https://js.stripe.com/v3/';
			script.onload = () => {
				console.log('Stripe Loaded');
				// Initialize Stripe
				this.stripe = Stripe(this.publicApiKey);
			};
			// Add the script to the DOM
			document.body.appendChild(script);
			this.isLoaded = true;
		}
	}

	// # APEX

	@wire(CurrentPageReference)
	currentPageReference;

	@wire(getCampaign, { campaignId: '$campaignId' })
	wiredCampaign({ error, data }) {
		if (data) {
			this.campaign = data;
		} else if (error) {
			console.log(error);
		}
	}

	getProcessingFee() {
		getProcessingFee()
			.then((r) => {
				this.processingFee = r;
			})
			.catch((e) => {
				console.log(e);
			});
	}

	getSettings() {
		getSettings()
			.then((r) => {
				this.settings = r;
			})
			.catch((e) => console.log(e));
	}

	getDonationAmounts() {
		getDonationAmounts()
			.then((r) => {
				this.donationAmounts = {
					month: null,
					once: null,
				};
				r.forEach((e) => {
					let amountArr = [];
					if (e.Auto_Calculate__c) {
						let currentAmount = e.Starting_Amount__c.toFixed(2);
						for (let i = 0; i < 6; i++) {
							amountArr.push(currentAmount);
							currentAmount = Math.round(
								currentAmount * (1 + e.Percentage_to_Auto_Calculate__c * 0.01)
							).toFixed(2);
							console.log(currentAmount);
						}
					} else {
						amountArr.push(
							e.Giving_Amount_1__c,
							e.Giving_Amount_2__c,
							e.Giving_Amount_3__c,
							e.Giving_Amount_4__c,
							e.Giving_Amount_5__c,
							e.Giving_Amount_6__c
						);
					}

					if (e.DeveloperName === 'Recurring') {
						this.donationAmounts.month = amountArr;
					} else if (e.DeveloperName === 'One_Time') {
						this.donationAmounts.once = amountArr;
					}
				});
				this.givingType = 'once';
				this.recurFreq = 'month';
				console.log(this.donationAmounts);
			})
			.catch((e) => {
				console.log(e);
			});
	}

	createTicketRecords() {
		createTicketRecords({
			payerJson: JSON.stringify(this.payerData.detail),
			campaignId: this.campaignId,
			ticketCount: this.ticketCount,
		});
	}

	getAssociatedFunds(campaignId, oscId) {
		if (campaignId != null) {
			getAssociatedFunds({ campaignOrOscId: this.campaignId, SObjType: 'campaign' })
				.then((r) => {
					this.funds = r;
					console.log(JSON.stringify(r));
				})
				.catch((e) => {
					console.log(e);
				});
		} else if (oscId != null) {
			getAssociatedFunds({ campaignOrOscId: this.oscId, SObjType: 'osc' })
				.then((r) => {
					this.funds = r;
					console.log(JSON.stringify(r));
				})
				.catch((e) => {
					console.log(e);
				});
		}
	}

	// # PRIVATE METHODS

	showToast(title, msg, variant, mode = 'dismissible') {
		const toastContainer = ToastContainer.instance();
		toastContainer.toastPosition = 'top-center';
		toastContainer.maxShown = 1;
		const event = new ShowToastEvent({
			title: title,
			message: msg,
			variant: variant,
			mode: mode,
		});
		this.dispatchEvent(event);
	}

	unfocusBtn(btn) {
		btn.classList.remove('slds-button_brand');
		btn.classList.add('slds-button_neutral');
	}

	focusBtn(btn) {
		btn.classList.remove('slds-button_neutral');
		btn.classList.add('slds-button_brand');
	}

	validate() {
		const validLI = [...this.template.querySelectorAll('.honorInfo lightning-input')].reduce((isValid, inp) => {
			inp.reportValidity();
			let valid = inp.checkValidity();

			return isValid && valid;
		}, true);
		const validOrgLI = [...this.template.querySelectorAll('.orgInfo lightning-input')].reduce((isValid, inp) => {
			inp.reportValidity();
			let valid = inp.checkValidity();

			return isValid && valid;
		}, true);
		const validMatchLI = [...this.template.querySelectorAll('.matchInfo lightning-input')].reduce(
			(isValid, inp) => {
				inp.reportValidity();
				let valid = inp.checkValidity();

				return isValid && valid;
			},
			true
		);
		const validLCB = [...this.template.querySelectorAll('.honorInfo lightning-combobox')].reduce((isValid, inp) => {
			inp.reportValidity();
			let valid = inp.checkValidity();

			return isValid && valid;
		}, true);
		const validOrgLCB = [...this.template.querySelectorAll('.orgInfo lightning-combobox')].reduce(
			(isValid, inp) => {
				inp.reportValidity();
				let valid = inp.checkValidity();

				return isValid && valid;
			},
			true
		);
		const validLTA = [...this.template.querySelectorAll('.honorInfo lightning-textarea')].reduce((isValid, inp) => {
			inp.reportValidity();
			let valid = inp.checkValidity();

			return isValid && valid;
		}, true);
		const validOrgLTA = [...this.template.querySelectorAll('.orgInfo lightning-textarea')].reduce(
			(isValid, inp) => {
				inp.reportValidity();
				let valid = inp.checkValidity();

				return isValid && valid;
			},
			true
		);
		if (validLI && validLCB && validLTA && validOrgLI && validOrgLCB && validOrgLTA && validMatchLI) {
			const li = [...this.template.querySelectorAll('.honorInfo lightning-input')].forEach((e) => {
				this.honoree.honoreeInfo[e.name] = e.value;
			});
			const lcb = [...this.template.querySelectorAll('.honorInfo lightning-combobox')].forEach((e) => {
				this.honoree.honoreeInfo[e.name] = e.value;
			});
			const lta = [...this.template.querySelectorAll('.honorInfo lightning-textarea')].forEach((e) => {
				this.honoree.honoreeInfo[e.name] = e.value;
			});
			const orgli = [...this.template.querySelectorAll('.orgInfo lightning-input')].forEach((e) => {
				this.org.orgInfo[e.name] = e.value;
			});
			const orglcb = [...this.template.querySelectorAll('.orgInfo lightning-combobox')].forEach((e) => {
				this.org.orgInfo[e.name] = e.value;
			});
			const orglta = [...this.template.querySelectorAll('.orgInfo lightning-textarea')].forEach((e) => {
				this.org.orgInfo[e.name] = e.value;
			});
			const matchli = [...this.template.querySelectorAll('.matchInfo lightning-input')].forEach((e) => {
				this.employer.employerInfo[e.name] = e.value;
			});

			// this.honoree = {
			// 	...this.honoree,
			// 	honorType: this.honorSelection,
			// };
		}
		return validLI && validLCB && validLTA && validOrgLI && validOrgLCB && validOrgLTA;
	}

	async checkoutWithStripe() {
		const token = this.settings.Stripe_API_Key__c;
		const payments = this.payments;
		const paymentLength = this.campaign.MaxPaymentLength__c;
		let ticketType = this.campaign.Type === 'Event';

		// Build payload body to create a checkout session
		let params = {
			'line_items[0][price_data][unit_amount]': ticketType
				? (Number(this.total) * 100) / this.ticketCount
				: Number(this.total) * 100,
			'line_items[0][quantity]': ticketType ? this.ticketCount : 1,
			'line_items[0][price_data][currency]': 'usd',
			'line_items[0][price_data][product_data][name]': ticketType
				? 'Registration(s): ' + this.campaign.Name
				: 'Donation',
			submit_type: ticketType ? 'pay' : 'donate',
			mode: 'payment',
			'payment_method_types[0]': 'card',
			'metadata[campaignId]': this.campaignId,
			'metadata[oscId]': this.oscId,
			'metadata[recurrence]': JSON.stringify(this.givingInterval),
			'metadata[anonymous]': this.anonymous,
			'metadata[organization]': JSON.stringify(this.org),
			'metadata[match]': JSON.stringify(this.employer),
			'metadata[honoree]': JSON.stringify(this.honoree),
			'metadata[type]': ticketType ? 'ticketing' : 'donation',
			ui_mode: 'embedded',
			return_url: this.callbackUrl,
			redirect_on_completion: 'if_required',
		};

		if (ticketType) {
			// Set payload parameters pertaining to ticket payments
			params.customer_email = this.payerData.detail.email;
			params['metadata[payer]'] = JSON.stringify(this.payerData.detail);

			if (this.payments) {
				// Set payload parameters pertaining to recurring payments
				params['line_items[0][price_data][unit_amount]'] =
					params['line_items[0][price_data][unit_amount]'] / paymentLength;
				params.mode = 'subscription';
				params.submit_type = 'subscribe';
				params['line_items[0][price_data][recurring][interval]'] = 'month';
				params['line_items[0][price_data][recurring][interval_count]'] = 1;
				params['metadata[paymentLength]'] = paymentLength;
				params['subscription_data[metadata][isTicket]'] = true;
			}
		} else {
			// Set payload parameters pertaining to donations
			params['phone_number_collection[enabled]'] = true;
			params.billing_address_collection = 'required';

			if (this.givingInterval.isRecurring) {
				// Set payload parameters pertaining to recurring donations
				params.mode = 'subscription';
				params.submit_type = 'subscribe';
				params['line_items[0][price_data][recurring][interval]'] = this.givingInterval.interval;
				params['line_items[0][price_data][recurring][interval_count]'] = this.givingInterval.intervalCount;
			}
		}

		// Convert params object to x-www-form-urlencoded string
		const body = new URLSearchParams(Object.entries(params)).toString();
		// console.log('Body: ', body);

		let checkoutId;

		const fetchClientSecret = async () => {
			// Send callout to create a Checkout Session
			const response = await fetch('https://api.stripe.com/v1/checkout/sessions', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
					Authorization: `Bearer ${token}`,
					'Accept-Encoding': "gzip, deflate, br'",
					Accept: '*/*',
				},
				body: body,
			});
			// Capture checkout session id and client secret
			// const { id, client_secret } = await response.json();
			const data = await response.json();
			// console.log('ClientSecret::', client_secret);
			// console.log('Checkout::', id);
			// console.log(data);
			checkoutId = data.id;
			return data.client_secret;
		};

		async function onComplete() {
			// Only enter if payments have been selected for ticketing
			if (payments) {
				try {
					// Send callout to get Checkout Session details
					const checkoutResponse = await fetch(`https://api.stripe.com/v1/checkout/sessions/${checkoutId}`, {
						method: 'GET',
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded',
							Authorization: `Bearer ${token}`,
							'Accept-Encoding': "gzip, deflate, br'",
							Accept: '*/*',
						},
					});
					if (!checkoutResponse.ok) {
						throw new Error(`Checkout Response status: ${checkoutResponse.status}`);
					}
					// Capture subscription ids from response
					const { subscription } = await checkoutResponse.json();
					// console.log(`Subscription ${subscription}`);

					if (subscription != null) {
						// Send callout to create a subscription schedule
						let schedule = await fetch('https://api.stripe.com/v1/subscription_schedules', {
							method: 'POST',
							headers: {
								'Content-Type': 'application/x-www-form-urlencoded',
								Authorization: `Bearer ${token}`,
								'Accept-Encoding': "gzip, deflate, br'",
								Accept: '*/*',
							},
							body: new URLSearchParams(
								Object.entries({
									from_subscription: subscription,
								})
							).toString(),
						});
						if (!schedule.ok) {
							throw new Error(`Subscription Response status: ${schedule.status}`);
						}
						// Capture the subscription schedule response
						schedule = await schedule.json();
						// console.log('Schedule::', schedule);

						// Remap first schedule phase for ease of use
						const phases = schedule.phases.map((phase) => ({
							start_date: phase.start_date,
							end_date: phase.end_date,
							items: phase.items,
						}));

						// Send callout to update the subscription schedule and set the term length
						schedule = await fetch(`https://api.stripe.com/v1/subscription_schedules/${schedule.id}`, {
							method: 'POST',
							headers: {
								'Content-Type': 'application/x-www-form-urlencoded',
								Authorization: `Bearer ${token}`,
								'Accept-Encoding': "gzip, deflate, br'",
								Accept: '*/*',
							},
							// Pass in the first phase (required) and add a second phase to set the term length
							body: new URLSearchParams(
								Object.entries({
									end_behavior: 'cancel',
									'phases[0][start_date]': phases[0].start_date,
									'phases[0][end_date]': phases[0].end_date,
									'phases[0][items][0][price]': phases[0].items[0].price,
									'phases[0][items][0][quantity]': phases[0].items[0].quantity,
									'phases[1][items][0][price]': phases[0].items[0].price,
									'phases[1][items][0][quantity]': phases[0].items[0].quantity,
									'phases[1][iterations]': paymentLength - 1,
								})
							).toString(),
						});
						if (!schedule.ok) {
							throw new Error(`Subscription Response status: ${schedule.status}`);
						}
						// console.log(await schedule.json());
					}
				} catch (error) {
					console.log(error.message);
				}
			}
		}

		try {
			// Initialize Embedded Checkout and set onComplete callback
			const checkout = await this.stripe.initEmbeddedCheckout({ fetchClientSecret, onComplete });

			// Mount Checkout
			checkout.mount('.checkout');

			// Dispatch custom event to hide LWC component on parent
			const event = new CustomEvent('hide', {
				detail: true,
			});
			this.dispatchEvent(event);
		} catch (error) {
			// console.log('Error::', error.message);
			this.showToast('Error', 'There is an issue with checkout. Please reload your page.', 'error');
		}
	}

	// # HANDLERS

	clickPaymentsButton() {
		this.payments = !this.payments;
	}

	changeDataInput(e) {
		this.payerData.detail[e.currentTarget.name] = e.currentTarget.value;
	}

	changeTicketCount(e) {
		this.ticketCount = e.detail.value;
		this.donationAmt =
			this.campaign.EventAmount__c !== 'undefined' ? this.campaign.EventAmount__c * this.ticketCount : 0;
	}

	clickHonorCheckBox(e) {
		this.honor = e.detail.checked;
		if (this.honor) {
			this.honorSelection = 'honor';
			this.honoree.honorType = 'honor';
		}
		this.honoree.isHonor = e.detail.checked;
	}

	clickMatchCheckbox(e) {
		this.match = e.detail.checked;
		this.employer.isMatch = e.detail.checked;
	}

	clickAnonymousCheckbox(e) {
		this.anonymous = e.detail.checked;
	}

	clickOrganizationCheckbox(e) {
		this.organization = e.detail.checked;
		this.org.isOrg = e.detail.checked;
	}

	honorGroupChanged(e) {
		this.honorSelection = e.detail.value;
		this.honoree.honorType = e.detail.value;
	}

	clickDonationTypeBtn(e) {
		this.template.querySelectorAll('.typeBtn').forEach((i) => {
			if (i.classList.contains('slds-button_brand')) {
				this.unfocusBtn(i);
			}
		});

		let btn = this.template.querySelector('#' + e.currentTarget.id);
		this.focusBtn(btn);

		this.givingType = e.currentTarget.value;
		this.showFreq = this.givingType === 'recur' ? true : false;
	}

	clickFreqTypeBtn(e) {
		this.template.querySelectorAll('.freqBtn').forEach((i) => {
			if (i.classList.contains('slds-button_brand')) {
				this.unfocusBtn(i);
			}
		});

		let btn = this.template.querySelector('#' + e.currentTarget.id);
		this.focusBtn(btn);

		this.recurFreq = e.currentTarget.value;
	}

	clickDonationAmtBtn(e) {
		let otherAmt = this.template.querySelector('[data-id="otherAmt"]');
		otherAmt.value = null;

		this.template.querySelectorAll('.amtBtns').forEach((i) => {
			if (i.classList.contains('slds-button_brand')) {
				this.unfocusBtn(i);
			}
		});

		let btn = this.template.querySelector('[name="' + e.currentTarget.name + '"]');
		this.focusBtn(btn);

		this.donationAmt = e.currentTarget.value;
	}

	changeOtherDonationAmt(e) {
		this.template.querySelectorAll('.amtBtns').forEach((i) => {
			if (i.classList.contains('slds-button_brand')) {
				this.unfocusBtn(i);
			}
		});

		this.donationAmt = e.detail.value;
	}

	checkFeeCheckbox(e) {
		this.addFee = e.currentTarget.checked;
	}

	clickDonateBtn() {
		if (this.validate()) {
			let interval;
			let count;
			if (this.showFreq) {
				switch (this.recurFreq) {
					case 'week':
						interval = 'week';
						count = 1;
						break;
					case 'biweek':
						interval = 'week';
						count = 2;
						break;
					case 'month':
						interval = 'month';
						count = 1;
						break;
					case 'quarter':
						interval = 'month';
						count = 3;
						break;
					case 'year':
						interval = 'year';
						count = 1;
						break;
					default:
						interval = 'once';
						count = 1;
						break;
				}
			} else {
				interval = 'once';
				count = 1;
			}

			this.givingInterval = {
				isRecurring: this.showFreq,
				interval: interval,
				intervalCount: count,
			};

			console.log('send to payment processor');
			if (this.campaign.Type === 'Event' && Number(this.total) === 0) {
				this.isSaving = true;
				this.createTicketRecords();
				setTimeout(() => {
					this.isSaving = false;
					this.isRegistered = true;
				}, 1500);
			} else {
				this.checkoutWithStripe();
			}
		}
	}

	// # GETTERS/SETTERS

	get honorOptions() {
		return [
			{ label: 'Honor', value: 'honor' },
			{ label: 'Memorial', value: 'memorial' },
		];
	}

	get ticketCountOptions() {
		return [
			{ label: '1', value: '1' },
			{ label: '2', value: '2' },
			{ label: '3', value: '3' },
			{ label: '4', value: '4' },
			{ label: '5', value: '5' },
			{ label: '6', value: '6' },
			{ label: '7', value: '7' },
			{ label: '8', value: '8' },
			{ label: '9', value: '9' },
			{ label: '10', value: '10' },
		];
	}

	get stateOptions() {
		return [
			{ label: 'Alabama', value: 'Alabama' },
			{ label: 'Alaska', value: 'Alaska' },
			{ label: 'Arizona', value: 'Arizona' },
			{ label: 'Arkansas', value: 'Arkansas' },
			{ label: 'California', value: 'California' },
			{ label: 'Colorado', value: 'Colorado' },
			{ label: 'Connecticut', value: 'Connecticut' },
			{ label: 'Delaware', value: 'Delaware' },
			{ label: 'Florida', value: 'Florida' },
			{ label: 'Georgia', value: 'Georgia' },
			{ label: 'Hawaii', value: 'Hawaii' },
			{ label: 'Idaho', value: 'Idaho' },
			{ label: 'Illinois', value: 'Illinois' },
			{ label: 'Indiana', value: 'Indiana' },
			{ label: 'Iowa', value: 'Iowa' },
			{ label: 'Kansas', value: 'Kansas' },
			{ label: 'Kentucky', value: 'Kentucky' },
			{ label: 'Louisiana', value: 'Louisiana' },
			{ label: 'Maine', value: 'Maine' },
			{ label: 'Maryland', value: 'Maryland' },
			{ label: 'Massachusetts', value: 'Massachusetts' },
			{ label: 'Michigan', value: 'Michigan' },
			{ label: 'Minnesota', value: 'Minnesota' },
			{ label: 'Mississippi', value: 'Mississippi' },
			{ label: 'Missouri', value: 'Missouri' },
			{ label: 'Montana', value: 'Montana' },
			{ label: 'Nebraska', value: 'Nebraska' },
			{ label: 'Nevada', value: 'Nevada' },
			{ label: 'New Hampshire', value: 'New Hampshire' },
			{ label: 'New Jersey', value: 'New Jersey' },
			{ label: 'New Mexico', value: 'New Mexico' },
			{ label: 'New York', value: 'New York' },
			{ label: 'North Carolina', value: 'North Carolina' },
			{ label: 'North Dakota', value: 'North Dakota' },
			{ label: 'Ohio', value: 'Ohio' },
			{ label: 'Oklahoma', value: 'Oklahoma' },
			{ label: 'Oregon', value: 'Oregon' },
			{ label: 'Pennsylvania', value: 'Pennsylvania' },
			{ label: 'Rhode Island', value: 'Rhode Island' },
			{ label: 'South Carolina', value: 'South Carolina' },
			{ label: 'South Dakota', value: 'South Dakota' },
			{ label: 'Tennessee', value: 'Tennessee' },
			{ label: 'Texas', value: 'Texas' },
			{ label: 'Utah', value: 'Utah' },
			{ label: 'Vermont', value: 'Vermont' },
			{ label: 'Virginia', value: 'Virginia' },
			{ label: 'Washington', value: 'Washington' },
			{ label: 'West Virginia', value: 'West Virginia' },
			{ label: 'Wisconsin', value: 'Wisconsin' },
			{ label: 'Wyoming', value: 'Wyoming' },
		];
	}

	get isHonor() {
		return this.honorSelection === 'honor';
	}

	get typeOnce() {
		return this.givingType === 'once';
	}

	get typeRecur() {
		return this.givingType === 'recur';
	}

	get fee() {
		return this.processingFee.Use_Flat_Fee__c
			? Number(this.processingFee.Flat_Fee__c).toFixed(2).toString()
			: (Number(this.donationAmt) * (Number(this.processingFee.Processing_Fee_Percentage__c) * 0.01))
					.toFixed(2)
					.toString();
	}

	get total() {
		return this.addFee
			? (Number(this.donationAmt) + Number(this.fee)).toFixed(2).toString()
			: Number(this.donationAmt).toFixed(2).toString();
	}

	get noTotal() {
		return Number(this.total) !== 0;
	}

	get feeCheckboxLabel() {
		return 'I would like to cover the processing fee by adding $' + this.fee + ' to my donation';
	}

	get selectedDonation() {
		return this.donationAmt !== 0;
	}

	get displayTotal() {
		return this.payments
			? 'Total Due: ' +
					this.campaign.MaxPaymentLength__c +
					' payments of $' +
					Number(this.donationAmt / this.campaign.MaxPaymentLength__c)
						.toFixed(2)
						.toString()
			: 'Total Due: $' + this.total;
	}

	get customTextColor() {
		return 'color:' + this.headerTextColor + ';font-size:x-large;';
	}

	get customHeaderColor() {
		return 'background-color:' + this.headerColor + ';';
	}

	get lockPayBtn() {
		if (this.campaign.EventAmount__c !== 0 && Number(this.total) === 0) {
			return true;
		} else if (this.campaign.EventAmount__c === 0 && this.ticketCount === 0) {
			return true;
		}
		return false;
	}

	get showPaymentsBtn() {
		return this.campaign.AllowPayments__c && Number(this.total) !== 0;
	}

	get loading() {
		return this.isSaving || this.isLoading;
	}
}
