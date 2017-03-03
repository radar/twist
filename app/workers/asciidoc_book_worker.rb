require 'fileutils'
require 'pathname'

require 'asciidoc_chapter'

class AsciidocBookWorker
  include Sidekiq::Worker

  def perform(id)
    book = Book.find(id)
    git = Git.new(book.github_user, book.github_repo)
    commit = update_git(git, book)
    path = htmlify_book(git.path, book)

    chapter_elements = Nokogiri::HTML.parse(File.read(path)).css(".sect1")
    chapter_elements.each_with_index do |chapter_element, index|
      AsciidocChapter.new(book, chapter_element, index).process
    end

    book.current_commit = commit
    book.processing = false
    book.just_added = false
    book.save
  end

  private

  def update_git(git, book)
    git.update!
    git.current_commit
  end

  def htmlify_book(path, book)
    book_file_candidates = [path + "book.ad", path + "book.adoc"]
    book_file = book_file_candidates.detect { |file| File.exist?(file) }

    unless book_file
      raise "Couldn't find book.ad or book.adoc at root of repository."
    end

    output_dir = Rails.root + "tmp/#{book.github_user}/#{book.github_repo}"
    FileUtils.rm_rf(output_dir)
    FileUtils.mkdir_p(output_dir)
    html_file = output_dir + "book.html"
    `asciidoctor -b html #{book_file} -o #{html_file}`
    html_file
  end
end
