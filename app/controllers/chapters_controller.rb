class ChaptersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_book

  def index
    redirect_to @book
  end
  
  def show
    @chapter = @book.chapters.find_by(permalink: params[:id])
    @previous_chapter = @book.chapters.find_by(position: @chapter.position.to_i-1)
    @next_chapter = @book.chapters.find_by(position: @chapter.position.to_i+1)
  end
  
  private
  
  def find_book
    @book = Book.find_by_permalink(params[:book_id])
  end
end
