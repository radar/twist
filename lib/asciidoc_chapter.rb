class AsciidocChapter
  def initialize(book, element, index)
    @book = book
    @element = element
    @index = index
  end

  def process
    book.chapters.create!(
      title: title,
      position: index,
      part: part,
    )
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

  def title
    element.css("h2").first.text
  end

  attr_reader :book, :element, :index
end
