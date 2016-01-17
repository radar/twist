class BraintreeWebhooksController < ApplicationController
  def incoming
    SubscriptionEvent.process_webhook(params.slice(:bt_signature, :bt_payload))
    render nothing: true
  end
end
