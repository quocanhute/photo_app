# config sidekiq.rb

Rails.application.config.after_initialize do
  require 'sidekiq'

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV.fetch("REDIS_URL"), db: 12}
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV.fetch("REDIS_URL"), db: 12}
  end
end