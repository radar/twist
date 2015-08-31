require "rails_helper"

feature "Adding books" do
  let(:account) { FactoryGirl.create(:account) }

  context "as the account's owner" do
    before do
      login_as(account.owner)
    end

    it "can add a book" do
      set_subdomain(account.subdomain)
      visit root_url
      click_link "Add Book"
      fill_in "Title", with: "Markdown Book Test"
      fill_in "GitHub Path", with: "radar/markdown_book_test"
      click_button "Add Book"
      expect(page).to have_content("Markdown Book Test has been enqueued for processing.")
    end
  end
end
