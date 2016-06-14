class BraintreeWebhooksController < ApplicationController
  def incoming
    webhook_params = params.permit(:bt_signature, :bt_payload).to_h
    SubscriptionEvent.process_webhook(webhook_params)
    head :ok
  end
end
