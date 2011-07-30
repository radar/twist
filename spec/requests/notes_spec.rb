require 'spec_helper'

describe "notes" do
  let(:user) { create_user! }
  before do
    create_book!
    actually_sign_in_as(user)
  end
    
  it "can add a new note to a paragraph and leave a comment on it", :js => true do
    visit book_chapter_path(@book, @book.chapters.first)
    within "#note_button_ch01_3" do
      click_link "0 notes +"
    end
    fill_in "note_text", :with => "This is a **test** note!"
    click_button "Leave Note"
    page.should have_content("1 note +")
    click_link "All notes for this chapter"
    click_link "This is a test note!"
    page.should have_content("user@example.com writes:")
    # Ensure note text shows up correctly in processed markdown.
    within "#note" do
      within("strong") { page.should have_content("test") }
    end

    # And the rest of it.
    page.should have_content("This is a test note!")
    
    fill_in "comment_text", :with => "**This** _is_ a `comment`"
    click_button "Leave Comment"
    page.should have_content("Comment has been created.")
    within "#comments" do
      within("p") do
        # Ensure comment text shows up correctly in processed markdown.
        within("strong") { page.should have_content("This") }
        within("em") { page.should have_content("is") }
        within("code") { page.should have_content("comment") }
      end
    end
  end
end