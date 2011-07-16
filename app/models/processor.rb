module Processor
  
  def build_element(markup, name)
    new(:tag        => name,
        :content    => markup.to_html,
        :identifier => markup["id"])
  end
  
  def process!(chapter, markup)
    send("process_#{markup.name}!", chapter, markup)
  end

  def process_p!(chapter, markup)
    paragraph = build_element(markup, "p")
    chapter.elements << paragraph
    content = markup.to_html
    markup.css("span.footnote").each do |footnote|
      chapter.footnote_count += 1
      footnote_link = "<a href='#footnote_#{chapter.footnote_count}'><sup>#{chapter.footnote_count}</sup></a>"
      content = content.gsub(/<span class="footnote" id="#{footnote["id"]}">(.*?)<\/span>/, footnote_link)
      process_footnote!(chapter, footnote)
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
                  :identifier => markup["id"],
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
                     :identifier => markup["id"],
                     :content    => markup.css("h4").to_html)

    chapter.elements << formalpara
    # Iterate through and process each sub-element of the formalpara separately
    markup.css("div.formalpara > *").each { |element| process!(chapter, element) }
    
    formalpara
  end
  
  def process_ul!(chapter, markup)
    chapter.elements << new(:tag        => "ul",
                            :identifier => markup["id"],
                            :content    => markup.to_html)
  end
  
  def process_informalexample!(chapter, markup)
    chapter.elements << new(:tag        => "informalexample",
                            :identifier => markup["id"],
                            :content    => markup.css("pre").to_html)
  end
  
  def process_example!(chapter, markup)
    chapter.elements << build_element(markup, "element")
  end
  
  def process_figure!(chapter, markup)
    chapter.elements << build_element(markup, "figure")
  end
  
  def process_table!(chapter, markup)
    chapter.elements << build_element(markup, "table")
  end
  
  def process_note!(chapter, markup)
    chapter.elements << build_element(markup, "note")
  end
  
  def process_indexterm!(chapter, markup)
    # TODO: process at a later date
  end
  
  def process_header!(chapter, markup)
    # headers are processed separately, we don't care about them in this context
  end
  
  alias_method :process_h1!, :process_header!
  alias_method :process_h2!, :process_header!
  alias_method :process_h3!, :process_header!
  
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