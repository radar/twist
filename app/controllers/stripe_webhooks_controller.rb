class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def receive
    SubscriptionEvent.process_webhook(
      params[:type],
      params[:data]
    )

    head :ok
  end
end
