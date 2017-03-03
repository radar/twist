class AsciidocChapterProcessor
  def initialize(chapter, chapter_element)
    @chapter = chapter
    @chapter_element = chapter_element
  end

  def process
    process_content(chapter, chapter_element.children)
  end

  private

  attr_reader :chapter, :chapter_element

  def process_content(chapter, elements)
    elements.each do |element|
      m = "process_#{element.name}"
      if respond_to?(m, true)
        send(m, chapter, element)
      else
        puts element.to_html
        raise "I don't know how to process a #{element.name}!"
      end
    end
  end

  def process_text(_chapter, element)
    # TODO: Is there any blank text we wish to include?
    element.text
  end

  # Real HTML elements that aren't divs

  def process_h2(chapter, element)
    chapter.elements.create!(
      tag: "h2",
      content: element.to_html
    )
  end

  def process_h3(chapter, element)
    chapter.elements.create!(
      tag: "h3",
      content: element.to_html
    )
  end

  def process_h4(chapter, element)
    chapter.elements.create!(
      tag: "h4",
      content: element.to_html
    )
  end

  def process_h5(chapter, element)
    chapter.elements.create!(
      tag: "h5",
      content: element.to_html
    )
  end

  def process_table(chapter, element)
    chapter.elements.create!(
      tag: "table",
      content: element.to_html
    )
  end

  # Div-ified elements after this point.

  def process_div(chapter, element)
    return unless element["class"]
    case element["class"]
    when "sectionbody"
      process_content(chapter, element.children)
    when "paragraph"
      process_paragraph(chapter, element)
    when "listingblock"
      process_listingblock(chapter, element)
    when "imageblock"
      process_imageblock(chapter, element)
    when "ulist"
      process_ulist(chapter, element)
    when "quoteblock"
      process_quoteblock(chapter, element)
    when /^admonitionblock/
      process_admonitionblock(chapter, element)
    when "sect2", "sect3", "sect4"
      process_content(chapter, element.children)
    else
      puts element.to_html
      raise "Unknown div #{element["class"]}!"
    end
  end

  def process_paragraph(chapter, element)
    chapter.elements.create!(
      tag: "p",
      content: element.css("p").to_html
    )
  end

  def process_listingblock(chapter, element)
    chapter.elements.create!(
      tag: "div",
      content: element
    )
  end

  def process_imageblock(chapter, element)
    # TODO: need to attach image to chapter?
    chapter.elements.create!(
      tag: "div",
      content: element
    )
  end

  def process_ulist(chapter, element)
    chapter.elements.create!(
      tag: "ul",
      content: element.css("ul").to_html
    )
  end

  def process_quoteblock(chapter, element)
    chapter.elements.create!(
      tag: "div",
      content: element
    )
  end

  def process_admonitionblock(chapter, element)
    chapter.elements.create!(
      tag: "div",
      content: element
    )
  end

end
