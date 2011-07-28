function create_section_listing() {
  $('div#sidebar h3').click(function(e) {
    window.scrollTo(0, 0);
  });

  $('.section_title').each(function (i, e) {
    $("div#sidebar").append("<div id='" + e.id + "_link'>" + e.innerText + "</div>");
    just_added = $("div#sidebar").children().last();
    if (e.tagName == "H2") {
      just_added.addClass("major");
    }
    else {
      just_added.addClass("minor");
    }
  });
  
  $('#sidebar div').click(function(e) {
    section_id = $(this).attr("id").replace("_link", "");
    window.scrollTo(0, $("#" + section_id)[0].offsetTop);
  })
}