class NoteNotifier
  include Sidekiq::Worker

  def perform(note_id)
    note = Note.find(comment_id)

    Notifier.new_note(note).deliver_now
  end
end
