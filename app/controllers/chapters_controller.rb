class ChaptersController < ApplicationController
  before_filter :find_book
  
  caches_action :show
  
  def show
    @chapter = @book.chapters.detect { |chapter| chapter.position == params[:id].to_i }
  end
  
  private
  
  def find_book
    @book = Book.find(params[:book_id])
  end
end