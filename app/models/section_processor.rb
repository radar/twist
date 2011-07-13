module SectionProcessor
  def process!(markup)
    @section_count ||= 0
    @section_count += 1
    id = markup["id"]
    # Create a tag so it can be rendered in-line for a chapter
    title_element = get_title(markup)
    title = "#{chapter.position}.#{@section_count} #{title_element.text}"
    # Re-use title_element to provide a header for this section
    title_element.content = title
    chapter.elements.create!(:tag        => "section",
                             :identifier => id,
                             :content    => title_element.to_html)

    # Also create a section so that it can appear in the table of contents for this chapter
    # This will also process the sub-elements inside this section
    section = create!(:title      => markup.css("h2").text,
                      :identifier => id,
                      :number     => @section_count)
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