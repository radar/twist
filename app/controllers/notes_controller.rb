class NotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_book_and_chapter
  before_filter :find_note, only: [:show, :complete, :reopen]
  before_filter :find_notes, only: [:index, :completed]

  def index
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
    element = @chapter.elements.find_by(nickname: params[:element_id])
    number = @book.notes_count + 1
    new_note_params = note_params.merge(
      number: number,
      user: current_user
    )

    note = element.notes.build(new_note_params)
    note.comments.first.user = current_user

    if note.save
      # Increment notes count for the book
      @book.notes_count += 1
      @book.save
      # create.js.erb
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
      @note = @book.notes.find_by(number: params[:id])
    end

    def find_book_and_chapter
      @book = Book.find_by_permalink(params[:book_id])
      @chapter = @book.chapters.find_by(permalink: params[:chapter_id]) if params[:chapter_id]
    end

    def note_params
      params.require(:note).permit(comments_attributes: [:text])
    end

end
