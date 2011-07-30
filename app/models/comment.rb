class Comment
  include Mongoid::Document
  field :text, :type => String
  field :user_id, :type => Integer

  belongs_to :user
  embedded_in :note

end