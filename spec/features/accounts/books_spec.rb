require "rails_helper"

  feature "Books" do
    let!(:account_a) { FactoryGirl.create(:account) }
    let!(:account_b) { FactoryGirl.create(:account) }

    before do
      FactoryGirl.create(:book, title: "Account A's Book", account: account_a)
      FactoryGirl.create(:book, title: "Account B's Book", account: account_b)
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
          book = account_a.books.first
          visit book_url(book)
          expect(page).to have_content(book.title)
        end

        it "cannot see Account B's book" do
          book = account_b.books.first
          visit book_url(book)
          expect(page).to have_content('Book not found.')
          expect(page.current_url).to eq(root_url)
        end
      end
    end
  end
