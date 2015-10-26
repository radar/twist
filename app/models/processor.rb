module Processor
  
  def build_element(markup, name)
    new({
      :tag        => name,
      :content    => markup.to_html,
      :nickname   => markup["id"] || Digest::MD5.hexdigest(markup.text + Time.now.to_s)
    })
  end
  
  def process!(chapter, markup)
    send("process_#{markup.name}!", chapter, markup)
  end

  def process_p!(chapter, markup)
    if markup.css('img').any?
      # TODO: can Markdown really contain multiple images in the same p tag?
      markup.css('img').each do |img|
        process_img!(chapter, img)
        chapter.elements << build_element(img, "img")
      end
    else
      paragraph = build_element(markup, "p")
      chapter.elements << paragraph
      paragraph.content = markup.to_html
      # Images are embedded in paragraphs in Markdown.
      # Need to extract and run through image processor.
      
      paragraph
    end
  end

  def process_img!(chapter, markup)
    # First, check to see if file is within book directory
    # This stops illegal access to files outside this directory
    image_path = File.expand_path(File.join(chapter.book.path, markup['src']))
    files = Dir[File.expand_path(File.join(chapter.book.path, "**", "*")) ]
    if files.include?(image_path)
      image = chapter.images.where(:filename => markup['src']).first
      image ||= chapter.images.build(:filename => markup['src'])
      image.tap do |i|
        i.image = File.open(image_path)
        i.save!
      end
    else
      # Ignore it
      false
    end
  end

  def process_div!(chapter, markup)
    # Divs have classes to identify them, separate them and process them as we see fit
    method = "process_#{markup["class"]}!"
    if self.respond_to?(method)
      send(method, chapter, markup)
    else
      # Or go kaboom if we don't know what the hell it is
      # Rollbar.log(:warning, "I don't know what to do with div.#{markup["class"]}")
    end
  end

  def process_ul!(chapter, markup)
    chapter.elements << new(:tag        => "ul",
                            :content    => markup.to_html)
  end

  def process_ol!(chapter, markup)
    chapter.elements << new(:tag        => "ol",
                            :content    => markup.to_html)
  end
  
  def process_table!(chapter, markup)
    chapter.elements << build_element(markup, "table")
  end
  
  def process_note!(chapter, markup)
    chapter.elements << build_element(markup, "note")
  end
  
  def process_warning!(chapter, markup)
    chapter.elements << build_element(markup, "warning")
  end
  
  def process_tip!(chapter, markup)
    chapter.elements << build_element(markup, "tip")
  end

  def process_code!(chapter, markup)
    chapter.elements << build_element(markup, "code")
  end

  def process_aside!(chapter, markup)
    chapter.elements << build_element(markup, "warning")
  end

  def process_footnote!(chapter, markup)
    chapter.elements << build_element(markup, "footnote")
  end

  def process_blockquote!(chapter, markup)
    chapter.elements << build_element(markup, "blockquote")
  end

  def process_hr!(chapter, markup)
    chapter.elements << build_element(markup, "hr")
  end

  def process_header!(chapter, markup)
    # headers are processed separately, we don't care about them in this context
  end
  
  def process_h1!(chapter, markup)
    # Already processed as the chapter title
  end

  def process_h2!(chapter, markup)
    chapter.elements << build_element(markup, "h2")
  end

  def process_h3!(chapter, markup)
    chapter.elements << build_element(markup, "h3")
  end

  def process_text!(chapter, markup)
    # We don't care about orphaned text, only text within an element such as a paragraph.
  end
end
