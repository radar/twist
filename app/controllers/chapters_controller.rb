class ChaptersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_book
  # caches_action :show

  def index
    redirect_to @book
  end
  
  def show
    @chapter = find_chapter(params[:id])
    @previous_chapter = find_chapter(params[:id].to_i-1)
    @next_chapter = find_chapter(params[:id].to_i+1)
  end
  
  private
  
  def find_book
    @book = Book.where(:permalink => params[:book_id]).first
  end

  def find_chapter(position)
    @book.chapters.detect { |chapter| chapter.position == position.to_i }
  end
end
