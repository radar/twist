class CommentsController < ApplicationController
  before_filter :authenticate_user!
  # lol embedded documents
  before_filter :find_book_and_chapter_and_note

  def create
    @comments = @note.comments
    attempt_state_update || create_new_comment
  end

  private

  def attempt_state_update
    if current_user.author?
      if params[:comment][:text].present?
        @comment = @note.comments.build(params[:comment].merge(:user => current_user))
      else
        @comment = Comment.new
      end
      change_note_state!
      flash.now[:notice] = "Note state changed to #{@note.state.titleize}"
      render "notes/show"
    else
      return false
    end
  end

  def create_new_comment
    @comment = @note.comments.build(params[:comment].merge!(:user => current_user))
    if @comment.save
      @comment.send_notifications!
      flash[:notice] = "Comment has been created."
      redirect_to [@book, @chapter, @note]
    else
      flash[:error] = "Comment could not be created."
      render "notes/show"
    end
  end

  def change_note_state!
    case params[:commit]
    when "Accept"
      @note.accept!
    when "Reject"
      @note.reject!
    when "Reopen"
      @note.reopen!
    end
  end
  
  def find_book_and_chapter_and_note
    @book = Book.where(permalink: params[:book_id]).first
    @chapter = @book.chapters.where(:position => params[:chapter_id]).first
    @note = @chapter.notes.where(:number => params[:note_id]).first
  end
  
end
