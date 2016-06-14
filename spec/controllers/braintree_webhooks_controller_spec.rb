require 'rails_helper'

RSpec.describe BraintreeWebhooksController, type: :controller do
  it "can parse a webhook from braintree" do
    webhook = { bt_signature: 'a signature', bt_payload: 'a payload' }
    expect(SubscriptionEvent).to receive(:process_webhook).with(webhook)
    post :incoming, params: webhook
    expect(response).to be_success
  end
end
