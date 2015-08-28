function create_section_listing() {
  $('div#sidebar h3').click(function(e) {
    window.scrollTo(0, 0);
  });

  $('.section_title').each(function (i, e) {
    $("div#sidebar #section_listing").append("<li><a id='" + e.id + "_link'>" + $(e).text() + "</a></li>");
    just_added = $("div#sidebar #section_listing").children().last();
    if (e.tagName == "H2") {
      just_added.addClass("major");
    }
    else {
      just_added.addClass("minor");
    }
  });

  $('#sidebar a').click(function(e) {
    var id = $(this).attr("id")
    if (id) {
      section_id = id.replace("_link", "");
      window.scrollTo(0, $("#" + section_id)[0].offsetTop);
    }
  })
}

$(document).ready(function() {
  if (location.hash) {
    $(location.hash).css("background", "cornsilk")
  }
})
