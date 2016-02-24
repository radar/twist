  require "stripe_plan_fetcher"
  desc "Import plans from Stripe"
  task import_plans: :environment do
    StripePlanFetcher.store_locally
  end
