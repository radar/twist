class Chapter < ActiveRecord::Base
  def self.process!(book, file)
    xml = Nokogiri::XML(File.read(file))
    book.chapters.create!(:title => xml.xpath("chapter/title").text)
  end
end
