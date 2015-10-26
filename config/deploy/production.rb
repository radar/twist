set :stage, :production

role :app, %w{ryanbigg@twistbooks.com}
role :db, %w{ryanbigg@twistbooks.com}

fetch(:default_env).merge!(rails_env: :production)
