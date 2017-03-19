class MarkdownChapterProcessor
  def initialize(book, file_name, part, position)
    @book = book
    @part = part
    @file_name = file_name
    @position = position
  end

  def process
    chapter = create_chapter
    html = to_html
    title = html.css("h1").text
    chapter.title = title
    chapter.permalink = title.parameterize
    elements = html.css("body > *")
    element_processor = MarkdownElementProcessor.new(chapter)
    elements.each do |element|
      element_processor.process!(element)
    end

    chapter.tap(&:save)
  end

  private

  attr_reader :book, :part, :file_name, :position

  def create_chapter
    book.chapters.create!(
      position: position + 1,
      commit: book.current_commit,
      file_name: file_name,
      part: part
    )
  end

  def to_html
    markdown = File.read(File.join(book.path, file_name))
    renderer = Redcarpet::Markdown.new(MarkdownRenderer, :fenced_code_blocks => true)
    html = Nokogiri::HTML(renderer.render(markdown))
  end
end
