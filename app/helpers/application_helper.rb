module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    raw(markdown.render(text))
  end

  def parse(text)
    text = find_and_replace_commit_refs(text)
    text = find_and_replace_note_refs(text)
    text
  end

  def find_and_replace_commit_refs(text)
    text.gsub(/\s@([a-f0-9]{5,32})/) { ("&nbsp;" + link_to("@#{$1}", "https://github.com/twist-books/rails-3-in-action/commit/#{$1}")).html_safe }
  end

  def find_and_replace_note_refs(text)
    text.gsub(/\s#(\d+)\s?/) { " " + link_to("##{$1}", book_note_path(@book, $1)) }
  end
end
