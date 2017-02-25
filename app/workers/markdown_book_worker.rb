class MarkdownBookWorker
  include Sidekiq::Worker

  def perform(id)
    book = Book.find(id)
    # TODO: determine if path is HTTP || Git
    # TODO: determine if path is public
    git = Git.new(book.github_user, book.github_repo)
    book.path = git.path.to_s
    book.current_commit = git.current_commit rescue nil
    git.update!

    markdown_book = MarkdownBook.new(book)
    manifest = markdown_book.process_manifest
    manifest.each do |part, file_names|
      file_names.each_with_index do |file_name, position|
        next if file_name.strip.blank?
        chapter = book.chapters.find_or_create_by(file_name: file_name, part: part)
        chapter.position = position + 1
        chapter.process!
      end
    end

    book.processing = false
    book.just_added = false
    book.save
  end
end
