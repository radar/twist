class CommentsController < ApplicationController
  before_filter :authenticate_user!
  # lol embedded documents
  before_filter :find_book_and_chapter_and_note
  
  def create
    @comment = @note.comments.build(params[:comment].merge!(:user => current_user))
    if @comment.save
      change_note_state!
      @comment.send_notifications!
      flash[:notice] = "Comment has been created."
      redirect_to [@book, @chapter, @note]
    else
      @comments = @note.comments
      flash[:error] = "Comment could not be created."
      render "notes/show"
    end
  end
  
  private

  def change_note_state!
    if current_user.author?
      case params[:commit]
      when "Accept"
        @comment.note.accept!
      when "Reject"
        @comment.note.rejected!
      when "Reopen"
        @comment.note.reopen!
      end
    end
  end
  
  def find_book_and_chapter_and_note
    @book = Book.where(permalink: params[:book_id]).first
    @chapter = @book.chapters.where(:position => params[:chapter_id]).first
    @note = @chapter.notes.where(:number => params[:note_id]).first
  end
  
end