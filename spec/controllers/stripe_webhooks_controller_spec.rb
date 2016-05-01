require "rails_helper"

describe StripeWebhooksController do
  it "can parse a webhook from Stripe" do
    type = "customer.subscription.created"
    data = {
      object: {
        id: "sub_00000000000000",
        customer: "cus_0000000000",
        object: "subscription"
      }
    }
    expect(SubscriptionEvent).to receive(:process_webhook).with(type, data)
    post :receive, {
      type: type,
      data: data
    }
    expect(response).to be_success
  end
end
