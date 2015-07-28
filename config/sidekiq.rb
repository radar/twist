redis_config = { url: 'redis://localhost:6379', namespace: 'twist' }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
