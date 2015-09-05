set :stage, :production
set :branch, 'my-saas'

role :app, %w{ryanbigg@twist.ryanbigg.com}
role :db, %w{ryanbigg@twist.ryanbigg.com}

fetch(:default_env).merge!(rails_env: :production)
