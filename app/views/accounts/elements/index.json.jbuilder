json.elements @elements do |element|
  json.id element.id
  json.tag element.tag
  json.content element.content
  json.notesCount "#{pluralize(element.notes_count, "note")}"
end
