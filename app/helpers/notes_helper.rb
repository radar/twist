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
end
