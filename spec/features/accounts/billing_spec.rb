require "rails_helper"

feature "Billing", js: true do
  let!(:account) { FactoryGirl.create(:account) }
  before do
    result = Braintree::Customer.create(
      payment_method_nonce: "fake-valid-nonce"
    )
    fail if !result.success?

    customer = result.customer

    result = Braintree::Subscription.create(
      payment_method_token: customer.credit_cards.first.token,
      plan_id: "starter"
    )
    fail if !result.success?

    account.braintree_customer_id = customer.id
    account.braintree_subscription_id = result.subscription.id
    account.save

    @original_payment_token = customer.credit_cards.first.token

    set_subdomain(account.subdomain)
    login_as(account.owner)
  end

  it "can update a credit card" do
    visit root_url
    click_link "Billing"

    within_frame "braintree-dropin-frame" do
      click_button "Change payment method"
    end

    within_frame "braintree-dropin-modal-frame" do
      find(".add-payment-method-link").click
      fill_in "Card Number", with: "4242 4242 4242 4242"
      fill_in "Expiration Date", with: "2/#{Time.now.year + 5}"
      fill_in "CVV", with: "123"
      click_button "Add new payment method"
    end

    within_frame "braintree-dropin-frame" do
      expect(page).to have_content("ending in 42")
    end

    click_button "Update payment method"
    expect(page).to have_content("Payment details have been updated.")

    subscription = Braintree::Subscription.find(account.braintree_subscription_id)
    expect(subscription.payment_method_token).not_to eq(@original_payment_token)
  end
end
