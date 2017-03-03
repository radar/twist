require 'asciidoc_chapter_processor'

class AsciidocChapter
  def initialize(book, element, index)
    @book = book
    @element = element
    @index = index
  end

  def process
    chapter = book.chapters.create!(
      title: title,
      position: index,
      part: part,
    )
    AsciidocChapterProcessor.new(chapter, element).process
  end

  def part
    case title
    when /\A\d+/
      "mainmatter"
    when /\AAppendix/
      "backmatter"
    else
      "frontmatter"
    end
  end

  private

  attr_reader :book, :element, :index

  def title
    element.css("h2").first.text
  end
end
