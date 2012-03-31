module ApplicationHelper
  def markdown(text)
    raw(RDiscount.new(text).to_html)
  end

  def parse(text)
    text.gsub(/\s@([a-f0-9]*)/) { link_to " @#{$1}", "https://github.com/radar/rails3book/commits/#{$1}" }
  end
end
