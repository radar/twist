namespace :book do
  task :load => :environment do
    Book.delete_all
    Book.create!(:title => "Rails 3 in Action", :path => "http://github.com/radar/rails3book")
  end
  
  task :ebook => :environment do
    book = Book.first
    epub_path = Rails.root + "epubs" + book.permalink
    total_nav = []
    FileUtils.mkdir_p(epub_path)
    book.chapters.each do |chapter|
      # Padded number will be "01"-"09" for first 9 chapters to ensure correct order in directory listing
      padded_number = "ch" + chapter.position.to_s.rjust(2, "0")
      
      # Define navigational element for chapter
      chapter_nav = { :label => "#{chapter.position}. #{chapter.title}", :content => "#{padded_number}.html", :nav => [] }
      
      # Build Chapter's HTML file
      chapter_path = epub_path + padded_number
      FileUtils.mkdir_p(chapter_path)
      File.open(chapter_path + "#{padded_number}.html", "w+") do |f|
        f.write <<-HEAD
        <html xmlns="http://www.w3.org/1999/xhtml" xmlns:ops="http://www.idpf.org/2007/ops" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <head>
            <title>Rails 3 in Action</title>
            <link href="style.css" rel="stylesheet" type="text/css"/>
            <link href="page-template.xpgt" rel="stylesheet" type="application/vnd.adobe-page-template+xml"/>
            <meta content="application/xhtml+xml; charset=utf-8" http-equiv="Content-Type"/>
          </head>
        <body>
        <h1>#{chapter.position}. #{chapter.title}</h1>
        HEAD
      
        output = ""
        chapter.elements.each do |e|
          if e.tag == "section"
            # Section number is always at the first
            section_parts = Nokogiri::HTML(e.content).text.split(" ")
            section_number, title = section_parts[0], section_parts.join(" ")
            # Define navigational element for chapter
            chapter_nav[:nav] << { :label => title, :content => "#{padded_number}.html##{section_number}"}
            # Insert an anchor tag just before the element so we can easily jump to it
            output << "<a name='#{section_number}'></a>"
          end 
          output << e.content
        end
      
        f.write(output)

        f.write <<-FOOT
          </body>
        </html>
        FOOT
      end
      total_nav << chapter_nav
      
    end
    
    figure_directories = Dir[Rails.root + "public/figures/#{book.id}/*"]
    figure_directories.each do |dir|
      FileUtils.cp_r(dir, epub_path)
    end

    epub = EeePub.make do
       files Dir["#{epub_path}/**/*.*"] + [(epub_path + "../style.css").to_s]
       title       'Rails 3 In Action'
       creator     'Ryan Bigg'
       publisher   'Manning'
       date        Date.today.strftime("%Y-%m-%d")
       identifier  'http://www.rails3inaction.com', :scheme => 'URL'
       uid         'http://www.rails3inaction.com'
       nav total_nav
     end
     epub.save('Rails3InActionBook.epub')
     puts "epub created."
    
  end
end