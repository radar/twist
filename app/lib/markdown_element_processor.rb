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
      create_element(markup.to_html, "p")
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
    if self.respond_to?(method, true)
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
    create_element(markup.to_html, "table")
  end

  def process_note!(markup)
    create_element(markup.to_html, "note")
  end

  def process_warning!(markup)
    create_element(markup.to_html, "warning")
  end

  def process_tip!(markup)
    create_element(markup.to_html, "tip")
  end

  def process_code!(markup)
    create_element(markup.to_html, "code")
  end

  def process_aside!(markup)
    create_element(markup.to_html, "warning")
  end

  def process_footnote!(markup)
    create_element(markup.to_html, "footnote")
  end

  def process_blockquote!(markup)
    create_element(markup.to_html, "blockquote")
  end

  def process_hr!(markup)
    create_element(markup, "hr")
  end

  def process_header!(markup)
    # headers are processed separately, we don't care about them in this context
  end

  def process_h1!(markup)
    # Already processed as the chapter title
  end

  def process_h2!(markup)
    create_element(markup.to_html, "h2")
  end

  def process_h3!(markup)
    create_element(markup.to_html, "h3")
  end

  def process_h4!(markup)
    create_element(markup.to_html, "h4")
  end

  def process_h5!(markup)
    create_element(markup.to_html, "h5")
  end

  def process_h6!(markup)
    create_element(markup.to_html, "h6")
  end

  def process_text!(markup)
    # We don't care about orphaned text, only text within an element such as a paragraph.
  end
end
