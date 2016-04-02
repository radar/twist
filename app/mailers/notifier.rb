class Notifier < ActionMailer::Base
  default :from => "notifications@twistbooks.com"

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(text).html_safe
  end
  helper_method :markdown

  def new_note(note)
    @book = note.chapter.book
    @comment = note.comments.first

    mail(
      to: book.account.owner,
      subject: note_subject(book, note)
    )
  end

  def comment(comment, email)
    @book = comment.note.chapter.book
    @comment = comment
    @note = comment.note

    mail(
      to: email,
      subject: note_subject(book, note)
    )
  end

  private

  def note_subject
    "[Twist] - #{@book.title} - Note ##{@comment.note.number}"
  end
end
