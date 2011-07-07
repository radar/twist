require 'spec_helper'

describe 'books' do
  context "registering a book" do
    let(:user) { Factory(:user) }

    before do
      sign_in(:user, user)
    end
    
    it "can register a book" do
      visit new_book_path
      fill_in "Title", :with => "Rails 3 in Action"
      fill_in "Path", :with => "http://github.com/radar/rails3book_test"
      click_button "Create Book"
      page.should have_content("Thanks! Your book is now being processed. Please wait.")
      click_link "Or if you're feeling impatient, click here to go to your book now."
    end
  end
end