require "rails_helper"

feature "Accounts" do
  scenario "creating an account" do
    visit root_path
    click_link "Create a new account"
    fill_in "Name", with: "Test"
    click_button "Create Account"

    within(".flash_notice") do
      success_message = "Your account has been created."
      expect(page).to have_content(success_message)
    end
  end
end
