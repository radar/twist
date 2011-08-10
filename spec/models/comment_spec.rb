require 'spec_helper'

describe Comment do
  let(:user_1) { create_user! }
  let(:user_2) { create_user!(:email => "user2@example.com") }
  let(:user_3) { create_user!(:email => "user3@example.com")}

  before do
    # First, we need to create a book and a note for some place in the book
    create_book!
    chapter = @book.chapters.first
    @note = chapter.notes.create!(:text => "This is a test note!", 
                                               :user => user_1, 
                                               :number => 1,
                                               :element => chapter.elements.first,
                                               :state => "complete")
    # Create a comment
    @note.comments.create!(:user => user_2, :text => "FIRST POST!")
    reset_mailer
  end

  context "upon creation" do
    it "sends an email to note author + commentors, minus comment owner" do
      comment = @note.comments.create!(:user => user_3, :text => "Second post")
      comment.send_notifications!

      email_1 = find_email("user@example.com")
      email_2 = find_email("user2@example.com")
      
      email_1.subject.should == "[Twist] - Rails 3 in Action - Note #1"
      email_2.subject.should == "[Twist] - Rails 3 in Action - Note #1"
    end
  end
end