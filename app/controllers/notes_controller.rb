class NotesController < ApplicationController

  def new
    @note = Note.new
  end
end