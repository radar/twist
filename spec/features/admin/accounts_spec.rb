require "rails_helper"

feature "Admin account dashboard" do
  let!(:starter_plan) do
    Plan.create(name: "Starter", amount: 995)
  end

  let!(:account) do
    FactoryGirl.create(:account, :subscribed, plan: starter_plan)
  end

  let!(:subscription_event) do
    account.subscription_events.create(type: "customer.subscription.created")
  end

  before do
    set_default_host
  end

  context "as an admin" do
    let!(:admin) do
      FactoryGirl.create(:user, admin: true)
    end

    before do
      login_as(admin)
    end

    scenario "it can find an account by its subdomain" do
      visit admin_root_path
      expect(page).to have_content("Find account by subdomain")
      fill_in "Subdomain", with: account.subdomain
      click_button "Search"

      expect(page.current_url).to eq(admin_account_url(account))
      expect(page).to have_content(account.name)
      expect(page).to have_content("Plan: #{starter_plan.name}")

      within("#subscription_events") do
        expect(page).to have_content("customer.subscription.created")
      end
    end
  end

  context "as a user" do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      login_as(user)
    end

    scenario "is unauthorized" do
      visit admin_root_path
      expect(page.current_url).to eq(root_url)
      within(".flash_alert") do
        expect(page).to have_content("You are not permitted to access that.")
      end
    end
  end
end
