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
    paragraph = build_element(markup, "p")
    chapter.elements << paragraph

    callout_count = 0
    content = markup.to_html
    # Parse footnotes
    markup.css("span.footnote").each do |footnote|
      chapter.footnote_count += 1
      footnote_link = "<a href='#footnote_#{chapter.footnote_count}' class='footnote'><sup>#{chapter.footnote_count}</sup></a>"
      content = content.gsub(/<span class="footnote" id="#{footnote["id"]}">(.*?)<\/span>/, footnote_link)
      process_footnote!(chapter, footnote)
    end

    # Parse callouts
    markup.css("span.callout").each do |callout|
      callout_count += 1
      image = "<img src='/images/callouts/#{callout_count}.png' class='callout'/>"
      content = content.gsub(callout.to_html, image)
    end

    paragraph.content = content
    paragraph
  end

  def process_div!(chapter, markup)
    # Divs have classes to identify them, separate them and process them as we see fit
    method = "process_#{markup["class"]}!"
    if self.respond_to?(method)
      send(method, chapter, markup)
    else
      # Or go kaboom if we don't know what the hell it is
      raise "I don't know what to do with div.#{markup["class"]}"
    end
  end

  def process_ul!(chapter, markup)
    chapter.elements << new(:tag        => "ul",
                            :content    => markup.to_html)
  end
  
  def process_figure!(chapter, markup)
    chapter.figure_count += 1
    filename = markup.css("img")[0]["src"]
    figure = chapter.figures.where(:filename => filename).first
    figure ||= chapter.figures.build(:filename => filename)
    figure.figure = File.open(chapter.git.path + filename)
    chapter.elements << build_element(markup, "figure")
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
