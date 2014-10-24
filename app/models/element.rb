class Element
  include Mongoid::Document
  extend Processor
  field :tag, :type => String
  field :xml_id, :type => String
  field :title, :type => String
  field :content, :type => String
  field :number, :type => Integer
  
  embedded_in :chapter
  embedded_in :note
  
  delegate :book, :to => :chapter
end
