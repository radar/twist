class Section < ActiveRecord::Base
  has_many :elements, :as => :parent, :extend => Processor
  has_many :sections, :foreign_key => "parent_id"
  belongs_to :parent, :foreign_key => "parent_id"
end
