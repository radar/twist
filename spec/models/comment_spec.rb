require 'rails_helper'

describe Comment do
  let(:user_1) { create_user! }
  let(:user_2) { create_user! }
  let(:user_3) { create_user! }
  let(:account) { FactoryGirl.create(:account) }
  let(:book) { create_book!(account) }
  let!(:note) do
    chapter = book.chapters.first
    element = chapter.elements.first
    note = element.notes.create!(
      text: "This is a test note!", 
      user: user_1, 
      number: 1,
      state: "complete"
    )
  end

  let!(:comment) do
    note.comments.create!(:user => user_2, :text => "FIRST POST!")
  end

  before do
    reset_mailer
  end

  context "upon creation" do
    it "sends an email to note author + commentors, minus comment owner" do
      comment = note.comments.create!(:user => user_3, :text => "Second post")
      comment.send_notifications!

      email_1 = find_email(user_1.email)
      email_2 = find_email(user_2.email)

      expect(email_1.subject).to eq("[Twist] - Markdown Book Test - Note #1")
      expect(email_2.subject).to eq("[Twist] - Markdown Book Test - Note #1")
    end

    it "sends notification emails to the right users" do
      comment = note.comments.build(:user => user_3)
      emails = comment.notification_emails
      expect(emails).to include(user_1.email)
      expect(emails).to include(user_2.email)
      expect(emails).not_to include(user_3.email)
    end
  end
end
