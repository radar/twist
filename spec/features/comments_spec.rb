require 'rails_helper'

describe 'commenting' do 
  let!(:account) { FactoryGirl.create(:account) }
  let!(:reviewer) { create_user! }
  let!(:book) { create_book!(account) }
  let!(:chapter) { book.chapters.first }
  let!(:element) { chapter.elements.first }
  let!(:note) { element.notes.create(:user => reviewer, :text => "My favourite element.", :number => 1) }
  let!(:comment_text) { "This is a typical comment" }

  def assert_comment_form_blank!
    expect(find("#comment_text").text).to be_blank
  end

  def assert_comment_present!
    within("#comments") do
      expect(page).to have_content(comment_text)
    end
  end

  context "as an account's owner" do
    before do
      login_as(account.owner)
      set_subdomain(account.subdomain)
      visit book_note_url(book, note)
      fill_in "comment_text", :with => comment_text
    end

    it "a normal comment" do
      click_button "Leave Comment"
      within(".flash_notice") do
        expect(page).to have_content("Comment has been created.")
      end
      assert_comment_form_blank!
      assert_comment_present!
    end

    it "accepting a note" do
      click_button "Accept"
      within(".flash_notice") do
        expect(page).to have_content("Note state changed to Accepted")
      end
      expect(note.reload.state).to eq('accepted')
      assert_comment_form_blank!
      assert_comment_present!
    end

    it "rejecting a note" do
      click_button "Reject"
      within(".flash_notice") do
        expect(page).to have_content("Note state changed to Rejected")
      end
      expect(note.reload.state).to eq('rejected')
      assert_comment_form_blank!
      assert_comment_present!
    end
  end
end
