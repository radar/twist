$(document).ready(function () {
  var handler = StripeCheckout.configure({
    key: 'pk_wjXwqqA2bXaEYbDm05Jz8CeHasd4E',
    image: '/images/logo.png',
    locale: 'auto',
    token: function(token) {
      $('form').append("<input type='hidden' name='token' value='" + token.id + "' />")
      $('form').submit();
    }
  });

  $('#payment-btn').on('click', function(e) {
    handler.open({
      name: 'Twist Books',
      currency: "aud",
      email: $('#email').val(),
      panelLabel: "Update payment details"
    });
    e.preventDefault();
  });

  // Close Checkout on page navigation
  $(window).on('popstate', function() {
    handler.close();
  });
});
