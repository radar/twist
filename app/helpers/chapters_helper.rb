module ChaptersHelper
  def previous_chapter_link
    if @previous_chapter
      ("&laquo; " + chapter_link(@previous_chapter)).html_safe
    end
  end

  def next_chapter_link
    if @next_chapter
      (chapter_link(@next_chapter) + " &raquo;".html_safe)
    end
  end

  private

  def chapter_link(chapter)
    name = ""
    name += "Chapter #{chapter.position}:" if chapter.part == "mainmatter"
    name += " " + chapter.title

    link_to(name, [@book, chapter])
  end
end
