module NotesHelper
  def avatar(user)
    # Do not connect out to gravatar in tests
    if user && !Rails.env.test?
      image_tag "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?s=140", :width => 50, :height => 50
    else
      image_tag "missing.png"
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
end
