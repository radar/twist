class ChaptersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_book
  caches_action :show

  def index
    redirect_to @book
  end
  
  def show
    @chapter = @book.chapters.detect { |chapter| chapter.position == params[:id].to_i }
  end
  
  private
  
  def find_book
    @book = Book.where(:permalink => params[:book_id]).first
  end
end