class Figure
  include Mongoid::Document
  
  field :filename, :type => String
  # A file representing the figure
  attr_accessor :figure
  
  embedded_in :chapter
  
  def save_attachment!
    book = self._parent._parent
    # Get relative path to the image from the book root
    relative_path = self.figure.path.gsub(book.path, "")
    new_figure_path = Pathname.new("public/figures/#{book.id}") + relative_path.gsub(/^\//,'')
    FileUtils.mkdir_p(File.dirname(new_figure_path))
    File.open(new_figure_path, "w+") do |f|
      f.write(File.read(self.figure.path))
    end
  end
end