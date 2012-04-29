require 'spec_helper'

describe 'commenting' do 
  let!(:author) { create_author! }
  let!(:reviewer) { create_user! }
  let!(:book) { create_book! }
  let!(:chapter) { book.chapters.first }
  let!(:element) { chapter.elements.where(:xml_id => "ch01_3").first }
  let!(:note) { chapter.notes.create(:user => reviewer, :text => "My favourite element.", :element => element, :number => 1) }
  let!(:comment_text) { "This is a typical comment" }

  def assert_comment_form_blank!
    find("#comment_text").text.should be_blank
  end

  def assert_comment_present!
    within("#comments") do
      page.should have_content(comment_text)
    end
  end

  context "as an author" do
    before do
      actually_sign_in_as(author)
      visit book_note_path(@book, note)
      fill_in "comment_text", :with => comment_text
    end

    it "a normal comment" do
      click_button "Leave Comment"
      within("#flash_notice") do
        page.should have_content("Comment has been created.")
      end
      assert_comment_form_blank!
      assert_comment_present!
    end

    it "accepting a note" do
      click_button "Accept"
      within("#flash_notice") do
        page.should have_content("Note state changed to Accepted")
      end
      note.reload.state.should == 'accepted'
      assert_comment_form_blank!
      assert_comment_present!
    end

    it "rejecting a note" do
      click_button "Reject"
      within("#flash_notice") do
        page.should have_content("Note state changed to Rejected")
      end
      note.reload.state.should == 'rejected'
      assert_comment_form_blank!
      assert_comment_present!
    end
  end
end
