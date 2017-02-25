require "rails_helper"

feature "Subscriptions", braintree: true do
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
    account.braintree_subscription_id = result.subscription.id
    account.save

    set_subdomain(account.subdomain)
    login_as(account.owner)
  end

  scenario "can be updated" do
    silver_plan = Plan.create(
      name: "Silver",
      braintree_id: "silver",
      price: 15,
      books_allowed: 3)

    visit root_url
    click_link "Change Plan"
    click_button "choose_silver"

    subscription = Braintree::Subscription.find(account.braintree_subscription_id)
    expect(subscription.plan_id).to eq("silver")

    account.reload
    expect(account.plan).to eq(silver_plan)

    within(".flash_notice") do
      expect(page).to have_content("You have changed to the Silver plan.")
    end
  end

  scenario "can be cancelled" do
    old_subscription_id = account.braintree_subscription_id

    visit root_url
    click_link "Change Plan"
    click_link "Cancel your subscription"
    within(".flash_notice") do
      expect(page).to have_content("Your subscription to Twist has been cancelled.")
    end

    sub = Braintree::Subscription.find(old_subscription_id)
    expect(sub.status).to eq('Canceled')

    account.reload
    expect(account.braintree_subscription_status).to eq('Canceled')
  end

  scenario "is prompted to upgrade plan when over limit" do
    starter_plan = Plan.create!(
      name: "Starter",
      braintree_id: "starter",
      books_allowed: 1,
    )

    silver_plan = Plan.create!(
      name: "Silver",
      braintree_id: "silver",
      books_allowed: 3
    )

    account.plan = starter_plan
    account.books << FactoryGirl.create(:book)
    account.save

    visit root_url
    click_link "Add Book"

    expect(page.current_url).to eq(choose_plan_url)

    within(".flash_alert") do
      message = "You have reached your plan's limit." +
        " You need to upgrade your plan to add more books."
      expect(page).to have_content(message)
    end

    click_button "choose_silver"

    within(".flash_notice") do
      expect(page).to have_content("You have changed to the Silver plan.")
    end

    expect(page.current_url).to eq(new_book_url)
  end
end
