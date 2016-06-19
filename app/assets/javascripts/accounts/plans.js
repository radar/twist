$(document).ready(function () {
  if (typeof(StripeCheckout) == 'undefined') { return }

  var handler = StripeCheckout.configure({
    key: 'pk_wjXwqqA2bXaEYbDm05Jz8CeHasd4E',
    image: '/images/logo.png',
    locale: 'auto',
    token: function(token) {
      $('form').append("<input type='hidden' name='token' value='" + token.id + "' />")
      $('form').submit();
    }
  });

  $('#checkout-btn').on('click', function(e) {
    selectedPlan = $(e.target).siblings('input:checked');
    // Open Checkout with further options
    handler.open({
      name: 'Twist Books',
      description: selectedPlan.data('name') + ' Plan',
      currency: "aud",
      amount: selectedPlan.data('amount')
    });
    e.preventDefault();
  });

  // Close Checkout on page navigation
  $(window).on('popstate', function() {
    handler.close();
  });
});
