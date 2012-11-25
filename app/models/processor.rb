module Processor
  
  def build_element(markup, name)
    new({
      :tag        => name,
      :content    => markup.to_html,
      :xml_id     => markup["id"] || Digest::MD5.hexdigest(markup.text)
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
  
  def process_footnote!(chapter, markup)
    # add a footnote tag immediately after the paragraph it is contained within
    chapter.elements << build_element(markup, "footnote")
    # Remove the footnote's elements from the dom, the footnote tag and its containing elements
    [markup, markup.children].flatten.map(&:remove)
  end
  
  def process_section!(chapter, markup)
    title = get_title_element(markup)
    
    # Increment last section count number
    chapter.section_count[-1] += 1
    original_title = title.text
    title.content = "#{chapter.section_count.join(".")} #{title.content}"

    section = new(:tag        => "section",
                  :title      => original_title,
                  :content    => title,
                  :xml_id     => markup["id"],
                  :number     => chapter.section_count[-1])
    # section_count > 2 if this section is a sub-section, 
    # in which case it would be picked up by the `within_section` code beneath
    chapter.elements << section #unless chapter.section_count.size > 2
    within_section(chapter) do
      markup.children.each do |element|
        process!(chapter, element)
      end
    end
    section
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
  
  def process_formalpara!(chapter, markup)
    # Create a new element which is just a <h4> of the title
    formalpara = new(:tag        => "formalpara",
                     :xml_id     => markup["id"],
                     :content    => markup.css("h4").to_html)

    chapter.elements << formalpara
    # Iterate through and process each sub-element of the formalpara separately
    markup.children.each { |element| process!(chapter, element) }
    
    formalpara
  end
  
  def process_ul!(chapter, markup)
    chapter.elements << new(:tag        => "ul",
                            :xml_id     => markup["id"],
                            :content    => markup.to_html)
  end
  
  def process_informalexample!(chapter, markup)
    # Remove excessive linebreaks
    pre = markup.css("pre")[0]
    pre.content = pre.content.strip
    informalexample = new(:tag        => "informalexample",
                            :xml_id     => markup["id"],
                            :content    => markup.css("pre").to_html)
    chapter.elements << informalexample
    informalexample
  end
  
  def process_example!(chapter, markup)
    chapter.listing_count += 1
    title = markup.css("span.title")[0]
    title.content = "Listing #{chapter.position}.#{chapter.listing_count} #{title.content}"
    chapter.elements << build_element(markup, "element")
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

  def process_indexterm!(chapter, markup)
    # TODO: process at a later date
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

  private
  
  # Used for sub-sections, will make section_count 
  def within_section(chapter)
    chapter.section_count.push(0)
    yield
    chapter.section_count.pop
  end
  
  def get_title_element(markup)
    title = markup.css("h2").first unless markup.css("h2").empty?
    title ||= markup.css("h3").first unless markup.css("h3").empty?
    title
  end
    
end
