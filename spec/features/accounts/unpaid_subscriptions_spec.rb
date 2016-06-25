require "rails_helper"

RSpec.feature "Unpaid subscriptions" do
  let(:account) do
    FactoryGirl.create(:account, :subscribed,
      stripe_subscription_status: "unpaid")
  end

  let(:book) { FactoryGirl.create(:book) }

  context "a user for the account" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      account.books << book
      account.users << user
      login_as(user)
      set_subdomain(account.subdomain)
    end

    it "cannot access the account's books" do
      visit book_path(book)
      expect(page.current_url).to eq(root_url)
      expect(page).to have_content("This account is currently disabled due to an unpaid subscription.")
      expect(page).to have_content("Please contact the account owner.")
    end
  end

  context "the owner of the account" do
    before do
      account.books << book
      login_as(account.owner)
      set_subdomain(account.subdomain)
    end

    it "cannot add a new book to the account" do
      visit new_book_path
      expect(page.current_url).to eq(billing_url)
      expect(page).to have_content("This account is currently disabled due to an unpaid subscription.")
      expect(page).to have_content("Please update your payment details to re-activate your subscription.")
    end
  end
end
