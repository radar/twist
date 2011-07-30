class NotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_book_and_chapter

  def index
    if @chapter
      @notes = @chapter.notes
    else
      @notes = @book.notes
    end
  end
  
  def show
    @note = @book.notes.detect { |n| n.number == params[:id].to_i }
    @chapter = @note._parent
    @comment = @note.comments.build
    @comments = @note.comments - [@comment]
  end

  def new
    @note = Note.new
    @notes = @chapter.notes.where(:element_identifier => params[:element_id])
  end
  
  def create
    element = @chapter.elements.where(:identifier => params[:element_id]).first
    note = @chapter.notes.build(params[:note].merge(:element => element, 
                                                    :element_identifier => params[:element_id],
                                                    :number => @book.notes_count + 1,
                                                    :user => current_user))
    if note.save
      # Increment notes count for the book
      @book.notes_count += 1
      @book.save
      # create.js.erb
    else
      # TODO: validation error if note text is blank
    end
  end
  
  private

    def find_book_and_chapter
      @book = Book.where(permalink: params[:book_id]).first
      @chapter = @book.chapters.where(:position => params[:chapter_id]).first if params[:chapter_id]
    end

end