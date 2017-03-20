require 'markdown_renderer'

class Chapter < ActiveRecord::Base
  PARTS = ["frontmatter", "mainmatter", "backmatter"]

  belongs_to :book

  has_many :elements, -> { order("id ASC") }
  has_many :images
  has_many :notes, through: :elements

  scope :ordered, -> { order("position ASC") }
  scope :frontmatter, -> { ordered.where(part: "frontmatter") }
  scope :mainmatter, -> { ordered.where(part: "mainmatter") }
  scope :backmatter, -> { ordered.where(part: "backmatter") }
  scope :commit, -> (commit) { where(commit: commit) }

  after_save :expire_cache

  # Defaults footnote_count to something.
  # Would use attr_accessor_with_default if it wasn't deprecated.
  def footnote_count
    @footnote_count ||= 0
  end

  # Default image count to 0, increments when we call process_figure! in Processor
  def image_count
    @image_count ||= 0
  end

  # Default listing count to 0, increments when we call process_example! in
  # Processor
  def listing_count
    @listing_count ||= 0
  end

  # Used for correctly counting + labelling the sections.
  # Works with the within_section method contained in the Processor module.
  #
  # Let's assume we're processing the first chapter of a book
  # For the first section, this variable will become:
  # [1, 1]
  # Next section:
  # [1, 1]
  # A sub-section of that section:
  # [1, 1, 1]
  # Then the next top-level section would be:
  # [1, 2]
  def section_count
    @section_count ||= [position, 0]
  end

  def previous_chapter
    # A previous chapter in the same part
    prev = book.chapters.find_by(part: part, position: position - 1)
    return prev if prev

    # The last chapter in the previous part
    current_part_index = PARTS.index(part)
    if current_part_index != 0
      book.chapters.where(part: PARTS[current_part_index-1]).order(position: :asc).last
    end
  end

  def next_chapter
    # The next chapter in the same part
    next_ch = book.chapters.find_by(part: part, position: position + 1)
    return next_ch if next_ch

    # The first chapter in the next part
    current_part_index = PARTS.index(part)
    if current_part_index != PARTS.count - 1
      book.chapters.where(part: PARTS[current_part_index+1]).order(position: :asc).first
    end
  end

  def to_param
    permalink
  end

  def part_position
    book.chapters.where(part: part).order(:position).pluck(:id).index(id) + 1
  end

  def expire_cache
    Rails.cache.delete_matched("*chapters/#{id}")
  end

end
