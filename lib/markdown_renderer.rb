class MarkdownRenderer < Redcarpet::Render::HTML
  def paragraph(text)
    # Is a tip
    if text.gsub!(/^T&gt;/, '')
      tip(text)
    else
      "<p>" + text + "</p>"
    end
  end

  def tip(text)
    paragraphs = text.gsub("\n\n", "</p><p>")
    "<div class='tip'><p>" + paragraphs + "</p></div>"
  end
end
