require 'asciidoc_chapter_processor'

class AsciidocChapter
  def initialize(book, element, index)
    @book = book
    @element = element
    @index = index
  end

  def process
    title_without_number = title.gsub(/^\d+\.\s+/, '')
    chapter = book.chapters.create!(
      title: title_without_number,
      permalink: title_without_number.parameterize,
      position: index,
      part: part,
    )
    AsciidocChapterProcessor.perform_async(book.id, chapter.id, element.to_s)
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
