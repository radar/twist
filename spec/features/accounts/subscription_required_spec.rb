require 'rails_helper'

feature 'Subscription required', braintree: true do
  let!(:account) { FactoryGirl.create(:account) }
  context "as an account owner" do
    before do
      login_as(account.owner)
      set_subdomain(account.subdomain)
    end

    scenario "Account owner must select a plan" do
      visit root_url
      expect(page.current_url).to eq(choose_plan_url)
      within(".flash_alert") do
        message = "You must subscribe to a plan before you can use your account."
        expect(page).to have_content(message)
      end
    end
  end

  context "as a regular user" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      account.users << user
      login_as(user)
      set_subdomain(account.subdomain)
    end

    scenario "they cannot access the account" do
      visit root_url
      expect(page.current_url).to eq(root_url(subdomain: nil))
      within(".flash_alert") do
        message = "There are subscription issues with the #{account.subdomain} account."
        message += " Please notify the account owner."
        expect(page).to have_content(message)
      end
    end
  end
end
