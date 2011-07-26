$(document).ready(function() {
  create_section_listing();
})

function create_section_listing() {
  $('div#section_listing h3').click(function(e) {
    window.scrollTo(0, 50);
  });

  $('.section_title').each(function (i, e) {
    $("div#section_listing").append("<div id='" + e.id + "_link'>" + e.innerText + "</div>");
  });
  
  $('#section_listing div').click(function(e) {
    section_id = $(this).attr("id").replace("_link", "");
    window.scrollTo(0, $("#" + section_id)[0].offsetTop);
  })
}