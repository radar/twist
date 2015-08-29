module NotesHelper
  def avatar(user)
    # Do not connect out to gravatar in tests
    if user && !Rails.env.test?
      image_tag "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?s=140"
    else
      image_tag "missing.png"
    end
  end

  def state(note)
    attributes = case note.state.titleize
                  when "Accepted"
                    { :class => "state-accepted" }
                  when "Rejected"
                    { :class => "state-rejected" }
                  when "New", "Reopened"
                    { :class => "state-new" }
                  end
    content_tag(:span, attributes) { note.state.titleize }
  end
end
