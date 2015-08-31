module ElementsHelper
  def render_elements(elements)
    elements.each do |element|
      concat(render_element(element))
    end
    nil
  end
  
  def render_element(element, show_notes: true)
    partial = find_element_partial(element) ? element.tag : "element"
    render("accounts/elements/#{partial}", element: element, show_notes: show_notes)
  end
  
  def render_footnote(element)
    @footnote_count ||= 0
    @footnote_count += 1
    footnote = Nokogiri::HTML(element.content)
    # TODO: Work out a better way to style the whole footnote container
    content_tag("span", :class => "footnote_container") do
      "<a name='footnote_#{@footnote_count}'></a><sup>fn #{@footnote_count}</sup> #{footnote.to_html}<br />".html_safe
    end
  end

  
  private

  def find_element_partial(element)
    @partials ||= {}
    return @partials[element.tag] unless @partials[element.tag].nil?
    partial = Rails.root + "app/views/accounts/elements/_#{element.tag}.html.erb"
    @partials[element.tag] = File.exist?(partial)
  end
end
