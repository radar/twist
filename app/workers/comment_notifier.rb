class CommentNotifier
  include Sidekiq::Worker

  def perform(comment_id, notification_emails)
    comment = Comment.find(comment_id)

    notification_emails.each do |email|
      Notifier.comment(comment, email).deliver_now
    end
  end
end
