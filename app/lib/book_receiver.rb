class BookReceiver
  def initialize(book)
    @book = book
  end

  def perform(payload)
    enqueue
    check_commits(payload["commits"]) if payload["commits"].present?
  end

  def enqueue
    @book.enqueue
  end

  def check_commits(commits)
    commits.each { |c| check_commit(c) }
  end

  def check_commit(commit)
    if /Fixes #(\d+)/.match(commit["message"])
      note = @book.notes.find_by(number: $1)
      note.accept! if note
    end
  end
end
