require "rails_helper"

feature "Books" do
  let!(:account_a) { FactoryGirl.create(:account_with_schema) }
  let!(:account_b) { FactoryGirl.create(:account_with_schema) }

  before do
    Apartment::Tenant.switch(account_a.subdomain) do
      Book.create(title: "Account A's Book", account: account_a)
    end

    Apartment::Tenant.switch(account_b.subdomain) do
      Book.create(title: "Account B's Book", account: account_b)
    end
  end

  context "index" do
    scenario "displays only account A's book" do
      set_subdomain(account_a.subdomain)
      login_as(account_a.owner)
      visit root_url
      expect(page).to have_content("Account A's Book")
      expect(page).to_not have_content("Account B's Book")
    end

    scenario "displays only account B's book" do
      set_subdomain(account_b.subdomain)
      login_as(account_b.owner)
      visit root_url
      expect(page).to have_content("Account B's Book")
      expect(page).to_not have_content("Account A's Book")
    end
  end

  context "show" do
    context "when signed in as account A's owner" do
      before do
        login_as(account_a.owner)
        set_subdomain(account_a.subdomain)
      end

      it "can see Account A's book" do
        book = nil
        Apartment::Tenant.switch(account_a.subdomain) do
          book = Book.first
        end

        visit book_url(book)
        expect(page).to have_content(book.title)
      end
    end
  end
end
