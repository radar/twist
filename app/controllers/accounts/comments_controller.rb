module Accounts
  class CommentsController < Accounts::BaseController
    # lol embedded documents
    before_action :find_book_and_chapter_and_note

    def create
      @comments = @note.comments
      check_for_state_transition!
      if params[:comment][:text].present?
        @comment = @note.comments.build(comment_params.merge!(user: current_user))
        if @comment.save
          @comment.send_notifications!
          flash[:notice] ||= "Comment has been created."
          redirect_to [@book, @chapter, @note]
        else
          flash[:error] = "Comment could not be created."
          render "notes/show"
        end
      else
        redirect_to [@book, @chapter, @note]
      end
    end

    private

    def check_for_state_transition!
      return unless owner?

      if params[:commit] == "Accept"
        @note.accept!
        notify_of_note_state_change("Accepted")
      elsif params[:commit] == "Reject"
        @note.reject!
        notify_of_note_state_change("Rejected")
      elsif params[:commit] == "Reopen"
        @note.open!
        notify_of_note_state_change("Open")
      end
    end

    def notify_of_note_state_change(state)
      flash[:notice] = "Note state changed to #{state}"
    end

    def find_book_and_chapter_and_note
      @book = find_book(params[:book_id])
      @chapter = find_chapter(@book, params[:chapter_id])
      @note = @chapter.notes.find_by(number: params[:note_id])
    end

    private

      def comment_params
        params.require(:comment).permit(:text)
      end
  end
end
