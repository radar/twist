class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:receive]
  skip_before_action :verify_authenticity_token, only: :receive

  def index
    @books = Book.where(hidden: false)
  end

  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(book_params)
    if @book.save
      @book.enqueue
      flash[:notice] = "Thanks! Your book is now being processed. Please wait."
      redirect_to book_path(@book)
    # else
    #   flash[:alert] = "Book could not be created."
    #   render :action => "new"
    end
  end
  
  def show
    @book = Book.find_by_permalink(params[:id])
    @frontmatter = @book.chapters.frontmatter
    @mainmatter = @book.chapters.mainmatter
    @backmatter = @book.chapters.backmatter
  end

  def receive
    @book = Book.find_by_permalink(params[:id])
    @book.enqueue
    head :ok
  end

  def book_params
    params.require(:book).permit(:title, :path, :blurb)
  end
end
