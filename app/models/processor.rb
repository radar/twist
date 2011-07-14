module Processor
  def process!(markup)
    @association.owner.elements.send("process_#{markup.name}!", markup)
  end

  def process_p!(markup)
    paragraph = create!(:tag => "p", :content => markup.to_html)
    content = markup.to_html
    markup.css("span.footnote").each do |footnote|
      Chapter.current_chapter.footnote_count ||= 0
      Chapter.current_chapter.footnote_count += 1
      footnote_link = "<a href='#footnote_#{Chapter.current_chapter.footnote_count.to_s}'><sup>#{Chapter.current_chapter.footnote_count}</sup></a>"
      content = content.gsub(/<span class="footnote" id="#{footnote["id"]}">(.*?)<\/span>/, footnote_link)
      process_footnote!(footnote)
      footnote.children.map(&:remove)
      footnote.remove
    end
    paragraph.content = content
    paragraph.save!
    paragraph
  end
  
  def process_footnote!(markup)
    create!(:tag        => "footnote",
            :content    => markup.to_html,
            :identifier => markup["id"])
  end

  def process_section!(markup)
    @association.owner.sections.process!(markup)
  end

  def process_div!(markup)
    # Divs have classes to identify them, separate them and process them as we see fit
    # I *REALLY REALLY WANT* to do this:
    #
    # method = "process_#{markup["class"]}!"
    # send(method, markup) if self.respond_to?(method, true)
    #
    # But it won't work? Wassup :extend?
    #
    # HACK HACK HACK around it:
    begin
      send("process_#{markup["class"]}!", markup)
    rescue NoMethodError
      # Or go kaboom if we don't know what the hell it is
      raise "I don't know what to do with div.#{markup["class"]}"
    end
  end
  
  def process_formalpara!(markup)
    # Create a new element which is just a <h4> of the title
    create!(:tag        => "formalpara",
            :identifier => markup["id"],
            :content    => markup.css("h4").to_html)
    # Iterate through and process each sub-element of the formalpara separately
    markup.css("div.formalpara > *").each { |element| @association.owner.elements.process!(element) }
  end
  
  def process_ul!(markup)
    create!(:tag        => "ul",
            :identifier => markup["id"],
            :content    => markup.to_html)
  end
  
  def process_informalexample!(markup)
    create!(:tag        => "informalexample",
            :identifier => markup["id"],
            :content    => markup.css("pre").to_html)
  end
  
  def process_example!(markup)
    create!(:tag        => "example",
            :identifier => markup["id"],
            :content    => markup.to_html)
  end
  
  def process_figure!(markup)
    @figure_count ||= 0
    @figure_count += 1
    create!(:tag        => "figure",
            :identifier => markup["id"],
            :content    => markup.to_html)
  end
  
  def process_table!(markup)
    create!(:tag         => "table",
            :identifier  => markup["id"],
            :content     => markup.to_html)
  end
  
  def process_note!(markup)
    create!(:tag        => "note",
            :identifier => markup["id"],
            :content    => markup.to_html)
  end
  
  def process_indexterm!(markup)
    # TODO: process at a later date
  end
  
  def process_header!(markup)
    # headers are processed separately, we don't care about them in this context
  end
  
  alias_method :process_h1!, :process_header!
  alias_method :process_h2!, :process_header!
  alias_method :process_h3!, :process_header!
  
  def process_text!(markup)
    # We don't care about orphaned text.
  end
  
  private
    
    # Convinience method to get to the chapter we're currently in
    def chapter
      @association.owner.chapter
    end
end