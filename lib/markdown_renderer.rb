class MarkdownRenderer < Redcarpet::Render::HTML
  def paragraph(text)
    # Is special
    if text.gsub!(/^(T|W|A)&gt;/, '')
      special(text, $1)
    else
      "<p>" + text + "</p>"
    end
  end

  def block_code(code, language)
    "<div class='code'>" + Pygments.highlight(code, :lexer => language) + "</div>"
  end

  def special(text, type)
    paragraphs = text.gsub("\n\n", "</p><p>")
    "<div class='#{convert_type(type)}'><p>" + paragraphs + "</p></div>"
  end

  def preprocess(full_document)
    full_document = full_document.gsub(/({.*?})\n(.*)\n\n/m) do
      preprocess_code($1, $2)
    end

    full_document
  end

  private

  def preprocess_code(details, code)
    output = ""
    details = Hash[details[1..-2].split(",").map do |detail|
      detail.split("=")
    end]
    if details['title']
      output = "**#{details['title']}**\n\n"
    end
    output += "```#{details['lang']}\n#{code}\n```\n\n"
    output
  end

  def convert_type(type)
    case type
      when 'T'
        'tip'
      when 'W'
        'warning'
      when 'A'
        'aside'
    end
  end
end
