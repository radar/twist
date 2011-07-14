module ElementsHelper
  def render_elements(elements)
    elements.each do |element|
      partial = find_element_partial(element) ? element.tag : "element"
      concat(render(:partial => "elements/#{partial}", :locals => { :element => element }))
    end
    nil
  end

  def find_element_partial(element)
    @partials ||= {}
    return @partials[element.tag] unless @partials[element.tag].nil?
    partial = Rails.root + "app/views/elements/_#{element.tag}.html.erb"
    @partials[element.tag] = File.exist?(partial)
  end
end