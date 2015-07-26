module ElementsHelper
  def render_elements(elements)
    elements.each do |element|
      concat(render_element(element))
    end
    nil
  end
  
  def render_element(element)
    partial = find_element_partial(element) ? element.tag : "element"
    render(:partial => "elements/#{partial}", :locals => { :element => element })
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
  
  def render_image(element)
    image_html = Nokogiri::HTML(element.content).css("img").first
    image = @chapter.images.find_by(filename: image_html["src"])
    content_tag(:div, :class => "figure") do
      image_tag(image.image.url) + "<br>"
      raw(image_html["alt"])
    end
  end
  
  private

  def find_element_partial(element)
    @partials ||= {}
    return @partials[element.tag] unless @partials[element.tag].nil?
    partial = Rails.root + "app/views/elements/_#{element.tag}.html.erb"
    @partials[element.tag] = File.exist?(partial)
  end
end
