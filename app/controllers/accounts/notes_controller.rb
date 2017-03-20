module Accounts
  class NotesController < Accounts::BaseController
    skip_before_action :verify_authenticity_token
    before_action :find_book_and_chapter
    before_action :find_note, only: [:show, :complete, :reopen]
    before_action :find_notes, only: [:index, :completed]

    def index
      @notes = @notes.where(state: ["new", "open"])
    end

    def show
      @chapter = @note.chapter
      @comment = @note.comments.build
      @comments = @note.comments - [@comment]
    end

    def new
      @note = Note.new
      @note.comments.build
      @element = Element.find_by(nickname: params[:element_id])
      @notes = @element.notes
    end

    def create
      @element = @chapter.elements.find(params[:element_id])
      number = @book.notes_count + 1
      note = @element.notes.build(
        state: "open",
        number: number,
        user: current_user
      )
      comment = note.comments.build(
        user: current_user,
        text: params[:note][:comment]
      )

      if note.save && comment.save
        Notifier.new_note(note).deliver_later
        @book.increment!(:notes_count)
        # Invalidates elements/index cache
        @chapter.touch
      else
        # TODO: validation error if note text is blank
      end
    end

    def completed
      @notes = @notes.where(state: ["accepted", "rejected"])
      @title = "Completed notes"
      render :index
    end

    private

      def find_notes
        if @chapter
          @notes = @chapter.notes
        else
          @notes = @book.notes
        end
      end

      def find_note
        @note = @book.notes.find_by!(number: params[:id])
      end

      def find_book_and_chapter
        @book = find_book(params[:book_id])
        @chapter = find_chapter(@book, params[:chapter_id]) if params[:chapter_id]
      end

      def note_params
        params.require(:note).permit(comments_attributes: [:text])
      end
  end
end
