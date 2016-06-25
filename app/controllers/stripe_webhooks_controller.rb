class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def receive
    SubscriptionEvent.process_webhook(
      params[:type],
      params[:data].permit!.to_h
    )

    head :ok
  end
end
