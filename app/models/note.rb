class Note
  include Mongoid::Document

  field :element_id, :type => Integer
  field :text, :type => String

end