class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, :type => String
  field :user_id, :type => Integer

  validates_presence_of :text

  belongs_to :user
  embedded_in :note
  
  # Send email notifications to all people "subscribed" to this note.
  def send_notifications!
    # The person who wrote the note, anybody who's left a comment on this note minus "current" comment creator
    notification_emails.each do |email|
      Notifier.comment(self, email).deliver
    end
  end

  def notification_emails
    (([note.user.email] + note.comments.map { |c| c.user.email }) - [self.user.email]).flatten.uniq
  end

end
