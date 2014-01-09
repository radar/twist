set :stage, :production

role :app, %w{ryanbigg@twist.ryanbigg.com}

fetch(:default_env).merge!(rails_env: :production)
