require 'spec_helper'

describe 'books' do
  context "registering a book" do
    let(:user) { create_user! }

    before do
      actually_sign_in_as(user)
    end
    
    it "can register a book" do
      pending
      click_link "New Book"
      fill_in "Title", :with => "Rails 3 in Action"
      fill_in "Path", :with => "http://github.com/radar/rails3book_test"
      click_button "Create Book"
      page.should have_content("Thanks! Your book is now being processed. Please wait.")
    end
    
    it "cannot register a book if not given a URL"
    it "cannot register a book if URL is inaccessible"
  end
end