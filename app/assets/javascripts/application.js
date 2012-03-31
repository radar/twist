// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(document).ready(function() {
  // Hide if page is on landscape
  if (Math.abs(window.orientation) == 90) {
    hide_sidebar()
  }
})

$(window).resize(function () {
  // Hide if page swaps to landscape
  if (Math.abs(window.orientation) == 90) {
    hide_sidebar()
  }
  else {
    $('#sidebar').show();
    $('.wrapper').css("margin", "1% 35% 0% 7%")
    $('#sidebar_tip').hide();
  }
})

function hide_sidebar() {
  $('#sidebar').hide();
  $('.wrapper').css("margin", "1% 5% 0% 7%")
  $('#sidebar_tip').show();
}
