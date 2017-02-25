class BraintreeWebhooksController < ApplicationController
  def incoming
    braintree_params = params.permit(:bt_signature, :bt_payload).to_h
    SubscriptionEvent.process_webhook(braintree_params)
    head :ok
  end
end
