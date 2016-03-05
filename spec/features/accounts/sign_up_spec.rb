require "rails_helper"

feature "Accounts" do
  let!(:plan) do
    Plan.create!(
      name: "Starter",
      stripe_id: "starter"
    )
  end

  scenario "creating an account", js: true do
    set_default_host

    visit root_path
    click_link "Create a new account"

    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "test"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Next"

    account = Account.last
    expect(account.stripe_customer_id).to be_present

    expect(page.current_url).to eq(choose_plan_url(subdomain: "test"))
    choose "Starter"

    click_button "Pay"
    within_frame("stripe_checkout_app") do
      fill_in "Email", with: "test@example.com"
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

    within(".flash_notice") do
      success_message = "Your account has been successfully created."
      expect(page).to have_content(success_message)
    end

    account.reload
    expect(account.plan).to eq(plan)
    expect(account.stripe_subscription_id).to be_present

    expect(page).to have_content("Signed in as test@example.com")
    expect(page.current_url).to eq(root_url(subdomain: account.subdomain))
  end

  scenario "Ensure subdomain uniqueness" do
    Account.create!(subdomain: "test", name: "Test")

    visit root_path
    click_link "Create a new account"
    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "test"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: 'password'
    click_button "Next"

    expect(page.current_url).to eq("http://lvh.me/accounts")
    expect(page).to have_content("Sorry, your account could not be created.")
    subdomain_error = find('.account_subdomain .help-block').text
    expect(subdomain_error).to eq('has already been taken')
  end
end
