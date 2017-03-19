class MarkdownBookWorker
  include Sidekiq::Worker

  def perform(id)
    book = Book.find(id)
    git = Git.new(book.github_user, book.github_repo)
    book.path = git.path.to_s
    git.update!
    book.current_commit = git.current_commit rescue nil

    markdown_book = MarkdownBook.new(book)
    manifest = markdown_book.process_manifest
    manifest.each do |part, file_names|
      file_names.each_with_index do |file_name, position|
        next if file_name.strip.blank?
        MarkdownChapterProcessor.new(book, file_name, part, position).process
      end
    end

    book.save
  end
end
