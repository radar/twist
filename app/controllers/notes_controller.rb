class NotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_book_and_chapter

  def index
    @notes = @chapter.notes
  end
  
  def show
    @note = @chapter.notes.where(:number => params[:id]).first
  end

  def new
    @note = Note.new
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
      @chapter = @book.chapters.where(:position => params[:chapter_id]).first
    end

end