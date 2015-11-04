require 'rails_helper'
feature 'Plans' do
  let!(:account) { FactoryGirl.create(:account) }
  before { login_as(account.owner) }
  scenario "Account owner must select a plan" do
    set_subdomain(account.subdomain)
    visit root_url
    expect(page.current_url).to eq(choose_plan_url)
    within(".flash_alert") do
      message = "You must subscribe to a plan before you can use your account."
      expect(page).to have_content(message)
    end
  end
end
