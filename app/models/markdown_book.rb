require 'pathname'

class MarkdownBook
  def initialize(book)
    @book = book
  end

  def process_manifest
    lines = File.readlines(Pathname.new(book.path) + "Book.txt")
    parts = Hash.new { |h, k| h[k] = [] }
    part = :mainmatter
    lines.each do |line|
      case line
      when /frontmatter/
        part = :frontmatter
      when /mainmatter/
        part = :mainmatter
      when /backmatter/
        part = :backmatter
      else
        unless line.strip.blank?
          parts[part] << line.strip
        end
      end
    end

    parts
  end

  private

  attr_reader :book
end
