require 'spec_helper'

describe 'books' do
  context "registering a book" do
    let(:user) { create_user! }

    before do
      actually_sign_in_as(user)
    end
    
    after do
      Resque.remove_queue("normal")
    end
    
    it "can register a book" do
      click_link "New Book"
      fill_in "Title", :with => "Rails 3 in Action"
      fill_in "Path", :with => "http://github.com/radar/rails3book_test"
      click_button "Create Book"
      page.should have_content("Thanks! Your book is now being processed. Please wait.")
    end
  end
end