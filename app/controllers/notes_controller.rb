class NotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_book_and_chapter
  before_filter :find_note, :only => [:show, :complete, :reopen]
  before_filter :find_notes, :only => [:index, :completed]

  def index
    @notes = @notes.select { |n| n.state != "complete" ||
                                 n.state != "accepted" ||
                                 n.state != "rejected"}
  end
  
  def show
    @chapter = @note._parent
    @comment = @note.comments.build
    @comments = @note.comments - [@comment]
  end

  def new
    @note = Note.new
    @notes = @chapter.notes.where(:element_id => params[:element_id])
  end
  
  def create
    element = @chapter.elements.where(:xml_id => params[:element_id]).first
    note = @chapter.notes.build(params[:note].merge(:element => element,
                                                    :element_id => params[:element_id],
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
  
  def complete
    @note.complete!
    flash[:notice] = "Note ##{@note.number} has been marked as completed!"
    redirect_to [@book, @chapter, :notes]
  end
  
  def reopen
    @note.reopen!
    flash[:notice] = "Note ##{@note.number} has been reopened!"
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
      @book = Book.where(permalink: params[:book_id]).first
      @chapter = @book.chapters.where(:position => params[:chapter_id]).first if params[:chapter_id]
    end

end
