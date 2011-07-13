class Section < ActiveRecord::Base
  has_many :elements, :order => "id ASC", :as => :parent, :extend => Processor
  has_many :sections, :foreign_key => "parent_id", :extend => SectionProcessor
  belongs_to :parent, :foreign_key => "parent_id"
  belongs_to :chapter
end
