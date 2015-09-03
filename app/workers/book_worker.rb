class BookWorker
  include Sidekiq::Worker

  def perform(id)
    book = Book.find(id)
    # TODO: determine if path is HTTP || Git
    # TODO: determine if path is public
    user, repo = book.path.split("/")[-2, 2]
    git = Git.new(user, repo)
    book.path = git.path.to_s
    current_commit = git.current_commit rescue nil
    git.update!

    Dir.chdir(book.path) do
      lines = File.readlines("Book.txt")
      manifest = book.process_manifest(lines)
      manifest.each do |part, lines|
        position = 1
        lines.each do |line|
          next if line.strip.blank?
          Chapter.process!(book, part, git, line.strip, position)
        end
      end
    end

    # When done, update the book with the current commit as a point of reference
    book.current_commit = git.current_commit
    book.processing = false
    book.just_added = false
    book.save
  end
end
