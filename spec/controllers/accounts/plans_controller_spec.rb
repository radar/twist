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

  context "as an admin user" do
    let!(:admin) { FactoryGirl.create(:user) }

    let!(:starter_plan) do
      Plan.create(
        name: "Starter",
        braintree_id: "starter",
        books_allowed: 1
      )
    end

    let!(:silver_plan) do
      Plan.create(
        name: "Silver",
        braintree_id: "silver",
        books_allowed: 3
      )
    end

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(admin)

      account.owner = admin
      account.plan = silver_plan
      account.books << FactoryGirl.create_list(:book, 3)
      account.save
    end

    context "with 3 books" do
      it "cannot switch to the starter plan" do
        expect(Braintree::Subscription).to_not receive(:update)
        put :switch, params: { plan_id: starter_plan.id }
        expect(flash[:alert]).to eq(
          "You cannot switch to that plan." +
          " Your account is over that plan's limit.")
        expect(response).to redirect_to(choose_plan_path)

        account.reload
        expect(account.plan).to eq(silver_plan)
      end
    end
  end
end
