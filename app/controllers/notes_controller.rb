class NotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_book_and_chapter
  before_filter :find_note, :only => [:show, :complete, :reopen]
  before_filter :find_notes, :only => [:index, :completed]

  def index
  end
  
  def show
    @chapter = @note.chapter
    @comment = @note.comments.build
    @comments = @note.comments - [@comment]
  end

  def new
    @note = Note.new
    @notes = @chapter.notes.where(:element_id => params[:element_id])
  end
  
  def create
    element = @chapter.elements.where(:nickname => params[:element_id]).first
    number = @book.notes.map(&:number).max.try(:+, 1) || 1
    new_note_params = note_params.merge(
      number: number,
      user: current_user
    )

    note = element.notes.build(new_note_params)

    if note.save
      # Increment notes count for the book
      @book.notes_count += 1
      @book.save
      # create.js.erb
    else
      # TODO: validation error if note text is blank
    end
  end
  
  def complete
    @note.complete!
    flash[:notice] = "Note ##{@note.number} has been marked as completed!"
    redirect_to [@book, @chapter, :notes]
  end
  
  def completed
    @notes = @notes.select { |n| n.state == "complete" }
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
      @note = @book.notes.detect { |n| n.number == params[:id].to_i }
    end

    def find_book_and_chapter
      @book = Book.where(permalink: params[:book_id], :hidden => false).first
      @chapter = @book.chapters.where(:position => params[:chapter_id]).first if params[:chapter_id]
    end

    def note_params
      params.require(:note).permit(:text)
    end

end
