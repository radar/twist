module ElementsHelper
  def render_elements(elements)
    elements.each do |element|
      partial = find_element_partial(element) ? element.tag : "element"
      concat(render(:partial => "elements/#{partial}", :locals => { :element => element }))
    end
    nil
  end
  
  def render_paragraph(element)
    # TODO: WRITE MORE GOOD
    # Seriously, what the fuck?
    @footnote_placeholder_count ||= 0
    @footnote_counter ||= 0
    footnotes = Nokogiri::HTML(element.content).css("span.footnote")
    content = element.content.gsub(/<span class="footnote"(.*?)>(.*?)<\/span>/) do
      @footnote_placeholder_count += 1
      content_tag("sup") do
        link_to(@footnote_placeholder_count, "#footnote_#{@footnote_placeholder_count}")
      end
    end
    concat(raw(content))
    footnotes.each do |footnote|
      @footnote_counter += 1
      footnote_element = content_tag("span", :class => "footnote") do
        anchor = content_tag("a", :name => "footnote_#{@footnote_counter}") { "#{@footnote_counter}" }
        "#{anchor} #{footnote.to_html}".html_safe
      end
      concat(footnote_element.html_safe)
    end
    nil
  end
  
  private

  def find_element_partial(element)
    @partials ||= {}
    return @partials[element.tag] unless @partials[element.tag].nil?
    partial = Rails.root + "app/views/elements/_#{element.tag}.html.erb"
    @partials[element.tag] = File.exist?(partial)
  end
end