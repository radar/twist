module ChaptersHelper
  def previous_chapter
    if @previous_chapter
      ("&laquo; " + chapter_link(@previous_chapter)).html_safe
    end
  end

  def next_chapter
    if @next_chapter
      (chapter_link(@next_chapter) + " &raquo;".html_safe)
    end
  end

  private

  def chapter_link(chapter)
    link_to("Chapter #{chapter.position}: #{chapter.title}", book_chapter_path(@book, chapter))
  end
end
