require 'rails_helper'

RSpec.describe Accounts::PlansController, type: :controller do
  let!(:account) { FactoryGirl.create(:account) }

  before do
    allow(controller).to receive(:current_account).and_return(account)
  end

  context "as a regular user" do
    let!(:user) do 
      FactoryGirl.create(:user).tap do |user|
        account.users << user
      end
    end

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(user)
    end

    it "cannot access the choose action" do
      get :choose
      root = root_url(subdomain: account.subdomain)
      expect(response).to redirect_to(root)

      message = "You are not allowed to do that."
      expect(flash[:alert]).to eq(message)
    end
  end
end
