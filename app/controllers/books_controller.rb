class BooksController < ApplicationController
  before_filter :authenticate_user!, :except => [:receive]

  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(params[:book])
    if @book.save
      flash[:notice] = "Thanks! Your book is now being processed. Please wait."
      redirect_to book_path(@book)
    # else
    #   flash[:alert] = "Book could not be created."
    #   render :action => "new"
    end
  end
  
  def show
    @book = Book.where(:permalink => params[:id]).first
  end

  def receive
    @book = Book.where(:permalink => params[:id]).first
    @book.enqueue(params[:payload])
    render :nothing => true
  end
end
