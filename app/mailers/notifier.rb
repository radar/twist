class Notifier < ActionMailer::Base
  defaults :from => "notifications@twist.ryanbigg.com"
  def comment(comment, email)
    @book = comment.note.chapter.book
    @comment = comment
    @note = comment.note

    mail(:to      => email,
         :subject => "[Twist] - #{@book.title} - Note ##{@comment.note.number}")
  end
end