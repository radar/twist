class BooksController < ApplicationController
  before_filter :authenticate_user!, :except => [:receive]
  skip_before_filter :verify_authenticity_token, :only => :receive

  def index
    @books = Book.where(hidden: false)
  end

  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(params[:book])
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
    @book = Book.where(:permalink => params[:id], :hidden => false).first
  end

  def receive
    @book = Book.find_by(:permalink => params[:id])
    @book.enqueue
    render :nothing => true
  end
end
