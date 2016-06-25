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
end
