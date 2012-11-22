class MarkdownRenderer < Redcarpet::Render::HTML
  def paragraph(text)
    # Is a tip
    if text.gsub!(/^(T|W)&gt;/, '')
      special(text, $1)
    else
      "<p>" + text + "</p>"
    end
  end

  def special(text, type)
    paragraphs = text.gsub("\n\n", "</p><p>")
    "<div class='#{convert_type(type)}'><p>" + paragraphs + "</p></div>"
  end

  private

  def convert_type(type)
    case type
      when 'T'
        'tip'
      when 'W'
        'warning'
    end
  end
end
