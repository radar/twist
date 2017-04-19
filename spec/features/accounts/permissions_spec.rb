require "rails_helper"

feature "Account permissions" do
  let(:account) { FactoryGirl.create(:account) }
  before do
    set_subdomain(account.subdomain)
  end

  scenario "cannot access the account if not owner or a user" do
    visit root_url
    sign_in_message = "You need to sign in or sign up before continuing."
    expect(page).to have_content(sign_in_message)
  end

  context "the account's owner" do
    let(:user) { account.owner }
    before do
      login_as(user)
    end

    scenario "can see the account" do
      visit root_url
      expect(page.current_url).to eq(root_url)
    end
  end

  context "a user of the account" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      account.users << user
      login_as(user)
    end

    scenario "can see the account" do
      visit root_url
      expect(page.current_url).to eq(root_url)
    end
  end

  context "an unauthorized user" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      login_as(user)
    end

    scenario "is not permitted to access the account" do
      visit root_url
      expect(page).to have_content("You are not permitted to view that account.")
      expect(page.current_url).to eq(root_url(subdomain: nil))
    end
  end
end
