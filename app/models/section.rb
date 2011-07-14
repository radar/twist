class Section < ActiveRecord::Base
  has_many :elements, :order => "id ASC", :as => :parent, :extend => Processor
  has_many :sections, :foreign_key => "parent_id", :extend => SectionProcessor
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "Section"
  belongs_to :chapter
  
  def ancestors
    ancestors = []
    section = self
    while section = section.parent
      ancestors << section
    end
    ancestors
  end
end
