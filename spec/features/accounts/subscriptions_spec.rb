require 'rails_helper'

feature 'Subscriptions' do
  let(:customer) do
    Stripe::Customer.create(
      source: {
        object: 'card',
        number: '4242' * 4,
        exp_month: Time.now.month,
        exp_year: Time.now.year + 1,
        cvc: '123'
      }
    )
  end

  let(:plan) { Plan.create(name: "starter", stripe_id: "starter")}
  let(:account) { FactoryGirl.create(:account) }

  before do
    subscription = customer.subscriptions.create(plan: "starter")
    account.stripe_customer_id = customer.id
    account.stripe_subscription_id = subscription.id
    account.save

    set_subdomain(account.subdomain)
    login_as(account.owner)
  end

  scenario "can be cancelled" do
    old_subscription_id = account.stripe_subscription_id

    visit root_url
    click_link "Change Plan"
    click_link "Cancel your subscription"
    within(".flash_notice") do
      expect(page).to have_content("Your subscription to Twist has been cancelled.")
    end

    account.reload
    expect(account.stripe_subscription_id).to be_blank
    active_subscriptions = customer.subscriptions.all
    expect(active_subscriptions.count).to eq(0)
  end

  scenario "can be updated" do
    silver_plan = Plan.create(
      name: "Silver",
      stripe_id: "silver",
      amount: 1500)

    visit root_url
    click_link "Change Plan"
    click_button "choose_silver"

    customer = Stripe::Customer.retrieve(account.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(account.stripe_subscription_id)
    expect(subscription.plan.id).to eq(silver_plan.stripe_id)

    account.reload
    expect(account.plan).to eq(silver_plan)

    within(".flash_notice") do
      expect(page).to have_content("You have changed to the Silver plan.")
    end
  end
end
