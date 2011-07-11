class ChaptersController < ApplicationController
  before_filter :find_book
  
  def show
    @chapter = @book.chapters.find_by_position(params[:id])
  end
  
  private
  
  def find_book
    @book = Book.find(params[:book_id])
  end
end