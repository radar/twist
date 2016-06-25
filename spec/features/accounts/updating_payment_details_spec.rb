require "rails_helper"

feature "Updating payment details", js: true do
  let!(:customer) { Stripe::Customer.create }
  let(:account) { FactoryGirl.create(:account, :subscribed, stripe_customer_id: customer.id) }

  context "as an account owner" do
    before do
      login_as(account.owner)
      set_subdomain(account.subdomain)
    end

    scenario "an account owner can change the account's payment details" do
      expect(customer.sources.count).to eq(0)

      visit root_path
      click_link "Billing Details"
      click_button "Update Payment Details"

      within_frame("stripe_checkout_app") do
        card_input = find("#card_number").native
        fill_in card_input["id"], with: "4242 4242 4242 4242"

        expiry = 1.month.from_now
        exp_input = find("#cc-exp").native
        exp_input.send_keys(expiry.strftime("%m"))
        sleep(0.25)
        exp_input.send_keys(expiry.strftime("%y"))

        csc_input = find("#cc-csc").native
        csc_input.send_keys("424")
        click_button "submitButton"
      end

      expect(page).to have_content("Your payment details have been updated.")

      customer = Stripe::Customer.retrieve(account.stripe_customer_id)
      expect(customer.sources.count).to eq(1)
      expect(customer.sources.first.last4).to eq("4242")
    end
  end
end
