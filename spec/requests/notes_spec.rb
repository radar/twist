require 'spec_helper'

describe "notes" do
  let(:user) { create_user! }
  before do
    create_book!
    actually_sign_in_as(user)
  end
    
  it "can add a new note to a paragraph", :js => true do
    visit book_chapter_path(@book, @book.chapters.first)
    within "#note_button_ch01_3" do
      click_link "0 notes +"
    end
    fill_in "note_text", :with => "This is a test note!"
    click_button "Leave Note"
    page.should have_content("1 note +")
    click_link "All notes for this chapter"
    click_link "This is a test note!"
    page.should have_content("user@example.com writes:")
    page.should have_content("This is a test note!")
  end
end