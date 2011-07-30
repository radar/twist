class CommentsController < ApplicationController
  before_filter :authenticate_user!
  # lol embedded documents
  before_filter :find_book_and_chapter_and_note
  
  def create
    comment = @note.comments.build(params[:comment].merge!(:user => current_user))
    if comment.save
      flash[:notice] = "Comment has been created."
      redirect_to [@book, @chapter, @note]
    else
      # TODO: Comment validations
    end
  end
  
  private
  
  def find_book_and_chapter_and_note
    @book = Book.where(permalink: params[:book_id]).first
    @chapter = @book.chapters.where(:position => params[:chapter_id]).first
    @note = @chapter.notes.where(:number => params[:note_id]).first
  end
  
end