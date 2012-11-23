class MarkdownRenderer < Redcarpet::Render::HTML
  def paragraph(text)
    # Is special
    if text.gsub!(/^(T|W)&gt;/, '')
      special(text, $1)
    else
      # Begins with a {, then on the next line contains fourspace indentation
      if text[0] == "{" && /\s+/.match(text.split("\n")[1])[0].length == 4
        p code(text)
        return code(text)
      end
      "<p>" + text + "</p>"
    end
  end

  def special(text, type)
    paragraphs = text.gsub("\n\n", "</p><p>")
    "<div class='#{convert_type(type)}'><p>" + paragraphs + "</p></div>"
  end

  def code(text)
    parts = text.split("\n") 
    details = parts.shift
    code = parts[1..-1].join("\n")
    details = Hash[details[1..-2].split(",").map do |detail|
      detail.split("=")
    end]
    "<div class='code'>" + Pygments.highlight(code, :lexer => details['lexer']) + "</div>"
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
