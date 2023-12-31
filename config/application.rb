require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PhotoApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.autoloader = :classic

    # Configuration for the application, engines, and railties goes here.
    config.i18n.load_path << Rails.root.join("config/locales/**/*.{rb,yml}")
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :vi]

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_job.queue_adapter = :sidekiq

    config.exceptions_app = self.routes
  end
end
