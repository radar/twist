module ApplicationHelper
  def markdown(text)
    raw(RDiscount.new(text).to_html)
  end
end
