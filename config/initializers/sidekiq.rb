require 'redis'
REDIS = Redis.new(:url => ENV['REDIS_URL'] || 'redis://localhost:6379/0')

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end

Sidekiq.configure_server do |config|
  config.redis = { :url => ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end
