module ApplicationHelper
  def markdown(text)
    raw(RDiscount.new(text).to_html)
  end

  def parse(text)
    text.gsub(/\s@([a-f0-9]{5,32})/) { ("&nbsp;" + link_to("@#{$1}", "https://github.com/twist-books/rails-3-in-action/commit/#{$1}")).html_safe }
  end
end
