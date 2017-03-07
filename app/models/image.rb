class Image < ActiveRecord::Base
  belongs_to :chapter

  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def figure_title
    "Figure #{chapter.part_position}.#{position} #{caption}"
  end
end
