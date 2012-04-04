function create_section_listing() {
  $('div#sidebar h3').click(function(e) {
    window.scrollTo(0, 0);
  });

  $('.section_title').each(function (i, e) {
    var content = e.innerText || e.textContent
    $("div#sidebar #section_listing").append("<a id='" + e.id + "_link'>" + content + "</a>");
    just_added = $("div#sidebar #section_listing").children().last();
    if (e.tagName == "H2") {
      just_added.addClass("major");
    }
    else {
      just_added.addClass("minor");
    }
  });
  
  $('#sidebar a').click(function(e) {
    section_id = $(this).attr("id").replace("_link", "");
    window.scrollTo(0, $("#" + section_id)[0].offsetTop);
  })
}