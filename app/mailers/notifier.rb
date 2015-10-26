class Notifier < ActionMailer::Base
  default :from => "notifications@twistbooks.com"

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(text).html_safe
  end
  helper_method :markdown

  def comment(comment, email)
    @book = comment.note.chapter.book
    @comment = comment
    @note = comment.note

    mail(:to      => email,
         :subject => "[Twist] - #{@book.title} - Note ##{@comment.note.number}")
  end
end
