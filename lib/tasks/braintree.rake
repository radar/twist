require "braintree_plan_fetcher"
desc "Import plans from Braintree"
task import_plans: :environment do
  BraintreePlanFetcher.store_locally
end
