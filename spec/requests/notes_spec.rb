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
  
  it "can view all notes for a book" do
    chapter = @book.chapters.first
    chapter.notes.create!(:text => "This is a test note!", 
                          :user => user, 
                          :number => 1,
                          :element => chapter.elements.first)
    
    visit book_path(@book)
    click_link "All notes for this book"
    click_link "This is a test note!"
    page.should have_content("user@example.com writes:")
    page.should have_content("This is a test note!")
  end
  
  it "can complete a note" do
    chapter = @book.chapters.first
    chapter.notes.create!(:text => "This is a test note!", 
                          :user => user, 
                          :number => 1,
                          :element => chapter.elements.first)
    
    visit book_path(@book)
    click_link "All notes for this book"
    click_link "This is a test note!"
    click_link "Mark note as complete"
    page.should have_content("Note #1 has been marked as completed!")
    
    # Note should no longer appear on main page, should be on completed list.
    page.should_not have_content("This is a test note!")
    
    click_link "Completed notes"
    page.should have_content("This is a test note!")
  end
  
  it "can reopen a note" do
    chapter = @book.chapters.first
    chapter.notes.create!(:text => "This is a test note!", 
                          :user => user, 
                          :number => 1,
                          :element => chapter.elements.first,
                          :state => "complete")
    
    visit book_path(@book)
    click_link "All notes for this book"
    page.should_not have_content("This is a test note!")
    visit book_note_path(@book, 1)
    click_link "Mark note as reopened"
    page.should have_content("Note #1 has been reopened!")
    # Validate content now appears on notes page.
    page.should have_content("This is a test note!")
  end

end
