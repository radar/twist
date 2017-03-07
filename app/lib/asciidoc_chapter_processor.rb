class AsciidocChapterProcessor
  include Sidekiq::Worker
  def perform(book_id, chapter_id, chapter)
    fragment = Nokogiri::HTML::DocumentFragment.parse(chapter)
    book = Book.find(book_id)
    chapter = book.chapters.find(chapter_id)
    process_content(chapter, fragment.children.first.children)
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

  # H2s are chapter titles, but Twist would rather they be h1s.
  # H1s in Asciidoc-land are book titles
  def process_h2(chapter, element)
    # Chapter titles are already handled, so no need to create one.
    # chapter.elements.create!(
    #   tag: "h1",
    #   content: element.to_html
    # )
  end

  def process_h3(chapter, element)
    create_header(chapter, "h2", element.text)
  end

  def process_h4(chapter, element)
    create_header(chapter, "h3", element.text)
  end

  def process_h5(chapter, element)
    create_header(chapter, "h4", element.text)

  end

  def create_header(chapter, header, text)
    chapter.elements.create!(
      tag: "#{header}",
      content: "<#{header}>#{text}</#{header}>"
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
    when /^olist/
      process_olist(chapter, element)
    when "quoteblock"
      process_quoteblock(chapter, element)
    when "sidebarblock"
      process_sidebarblock(chapter, element)
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
    src = element.css("img").first["src"]
    candidates = Dir[chapter.book.path + "**/#{src}"]
    # TODO: what if more than one image matches the path?
    image_path = candidates.first
    if File.exist?(image_path)
      chapter.images.create!(
        image: File.open(image_path),
        caption: element.css(".title").text.strip.gsub(/^Figure \d+\.\s+/, ''),
        position: chapter.images.count + 1
      )
    end

    chapter.elements.create!(
      tag: "img",
      content: src
    )
  end

  def process_ulist(chapter, element)
    chapter.elements.create!(
      tag: "ul",
      content: element.css("ul").to_html
    )
  end

  def process_olist(chapter, element)
    chapter.elements.create!(
      tag: "ol",
      content: element.css("ol").to_html
    )
  end

  def process_quoteblock(chapter, element)
    chapter.elements.create!(
      tag: "div",
      content: element
    )
  end

  def process_sidebarblock(chapter, element)
    chapter.elements.create!(
      tag: "div",
      content: element
    )
  end

  def process_admonitionblock(chapter, element)
    chapter.elements.create!(
      tag: "div",
      content: <<-HTML.strip
        <div class="#{element["class"]}">
          #{element.css(".content").first.inner_html.strip}
        </div>
      HTML
    )
  end
end
