module NotesHelper
  def avatar(user)
    content_tag(:span, :class => 'avatar') do
      if user
        image_tag "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?s=140", :width => 48, :height => 48
      else
        "poopie"
      end
    end
  end

  def state(note)
    attributes = case note.state.titleize
                  when "Accepted" || "Completed"
                    { :class => "state-accepted" }
                  when "Rejected"
                    { :class => "state-rejected" }
                  when "New"
                    { :class => "state-new" }
                  end
    content_tag(:span, attributes) { note.state.titleize }
  end

  def comment(object, blurb, attributes={})
    content_tag(:div, {:class => "comment"}.merge(attributes)) do
      avatar(object.user) +
      content_tag(:div, :class => 'comment_container') do
        content_tag(:div, :class => "container") do
          content_tag(:div, :class => "details") do
            content_tag(:div, :class => "info") do
              "<strong>#{object.user.try(:email) || "[deleted]"}</strong> #{blurb} <time>#{time_ago_in_words(object.created_at) + ' ago' if object.created_at}</time>".html_safe
            end +
            content_tag(:div, :class => "body") do
              markdown(parse(object.text))
            end
          end
        end
      end
    end
  end
end
