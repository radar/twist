class Comment
  include Mongoid::Document
  field :text, :type => String
  field :user_id, :type => Integer

  belongs_to :user
  embedded_in :note
  
  # Send email notifications to all people "subscribed" to this note.
  def send_notifications!
    # The person who wrote the note, anybody who's left a comment on this note minus "current" comment creator
    emails = (([note.user.email] + note.comments.map { |c| c.user.email }) - [self.user.email]).flatten.uniq
    p "Sending emails to the following people: #{emails}"
    emails.each do |email|
      Notifier.comment(self, email).deliver
    end
  end

end
