module SectionProcessor
  def process!(markup)
    @section_count ||= 0
    @section_count += 1
    
    # Create a section so that it can appear in the table of contents for this chapter
    # This will also process the sub-elements inside this section
    # Where "number" represents the section number within this chapter / section, not the full number
    id = markup["id"]
    section = create!(:title      => markup.css("h2").text,
                      :xml_id     => id,
                      :number     => @section_count)

    unless section.ancestors.empty?
      section.chapter = section.ancestors.first.chapter
      parent_sections = section.ancestors.map(&:number)
    end
    # Chapter number, then all parent sections
    number = [chapter.position, parent_sections, @section_count].flatten.compact.join(".")
    # Create a tag so it can be rendered in-line for a chapter
    title_element = get_title(markup)
    title = "#{number} #{title_element.text}"
    # Re-use title_element to provide a header for this section
    title_element.content = title
    chapter.elements.create!(:tag        => "section",
                             :xml_id     => id,
                             :content    => title_element.to_html)
    # Process direct child elements of this section.
    # Can include things like paragraphs or sections
    markup.children.each { |p| section.elements.process!(p) }
  end
  
  private
    def get_title(markup)
      title = markup.css("h2").first
      title = markup.css("h3").first if !title || title.text.blank?
      title
    end
    
    def chapter
      @association.owner.chapter
    end
end
