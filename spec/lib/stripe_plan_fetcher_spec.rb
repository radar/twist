require "rails_helper"
require "stripe_plan_fetcher"

describe StripePlanFetcher do
  let(:faux_plan) do
    double("Plan", 
             id: "starter",
             name: "Starter",
             amount: 995)
  end

  it "fetches and stores plans" do
    expect(Stripe::Plan).to receive(:all).and_return([faux_plan])
    expect(Plan).to receive(:create).with({
      stripe_id: "starter",
      name: "Starter",
      amount: 995
    })

    StripePlanFetcher.store_locally
  end

  it "checks and updates plans" do
    expect(Stripe::Plan).to receive(:all).and_return([faux_plan])
    expect(Plan).to receive(:find_by).
                                with(stripe_id: faux_plan.id).
                                and_return(plan = double)
    expect(plan).to receive(:update).with({
      name: "Starter",
      amount: 995
    })

    expect(Plan).to_not receive(:create)

    StripePlanFetcher.store_locally
  end
end
