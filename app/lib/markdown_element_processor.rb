class MarkdownElementProcessor
  def initialize(chapter)
    @chapter = chapter
  end

  def process!(markup)
    send("process_#{markup.name}!", markup)
  end

  private

  attr_reader :chapter

  def create_element(markup, name)
    chapter.elements.create!({
      tag: name,
      content: markup
    })
  end

  def process_p!(markup)
    if markup.css('img').any?
      # TODO: can Markdown really contain multiple images in the same p tag?
      markup.css('img').each do |img|
        process_img!(img)
        create_element(img.to_html, "img")
      end
    else
      create_element(markup, "p")
    end
  end

  def process_img!(markup)
    # First, check to see if file is within book directory
    # This stops illegal access to files outside this directory
    book = chapter.book
    image_path = File.expand_path(File.join(book.path, markup['src']))
    files = Dir[File.expand_path(File.join(book.path, "**", "*")) ]
    if files.include?(image_path)
      image = chapter.images.where(:filename => markup['src']).first
      image ||= chapter.images.build(:filename => markup['src'])
      image.tap do |i|
        i.image = File.open(image_path)
        i.save!
      end
    else
      Rollbar.warning("Missing image in #{book.title} - #{chapter.title}: #{image_path}")
      # Ignore it
      false
    end
  end

  def process_div!(markup)
    # Divs have classes to identify them, separate them and process them as we see fit
    method = "process_#{markup["class"]}!"
    if self.respond_to?(method)
      send(method, markup)
    else
      # Or go kaboom if we don't know what the hell it is
      # Rollbar.log(:warning, "I don't know what to do with div.#{markup["class"]}")
    end
  end

  def process_ul!(markup)
    create_element(markup.to_html, "ul")
  end

  def process_ol!(markup)
    create_element(markup.to_html, "ol")
  end

  def process_table!(markup)
    chapter.elements << create_element(markup, "table")
  end

  def process_note!(markup)
    chapter.elements << create_element(markup, "note")
  end

  def process_warning!(markup)
    chapter.elements << create_element(markup, "warning")
  end

  def process_tip!(markup)
    chapter.elements << create_element(markup, "tip")
  end

  def process_code!(markup)
    chapter.elements << create_element(markup, "code")
  end

  def process_aside!(markup)
    chapter.elements << create_element(markup, "warning")
  end

  def process_footnote!(markup)
    chapter.elements << create_element(markup, "footnote")
  end

  def process_blockquote!(markup)
    chapter.elements << create_element(markup, "blockquote")
  end

  def process_hr!(markup)
    chapter.elements << create_element(markup, "hr")
  end

  def process_header!(markup)
    # headers are processed separately, we don't care about them in this context
  end

  def process_h1!(markup)
    # Already processed as the chapter title
  end

  def process_h2!(markup)
    chapter.elements << create_element(markup, "h2")
  end

  def process_h3!(markup)
    chapter.elements << create_element(markup, "h3")
  end

  def process_h4!(markup)
    chapter.elements << create_element(markup, "h4")
  end

  def process_h5!(markup)
    chapter.elements << create_element(markup, "h5")
  end

  def process_h6!(markup)
    chapter.elements << create_element(markup, "h6")
  end

  def process_text!(markup)
    # We don't care about orphaned text, only text within an element such as a paragraph.
  end
end
