class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :note

  validates :text, presence: true
  
  # Send email notifications to all people "subscribed" to this note.
  def send_notifications!
    # The person who wrote the note, anybody who's left a comment on this note minus "current" comment creator
    notification_emails.each do |email|
      Notifier.delay.comment(self, email)
    end
  end

  def notification_emails
    (([note.user.email] + note.comments.map { |c| c.user.email }) - [self.user.email]).flatten.uniq
  end

end
