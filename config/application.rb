require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.hosts += ENV['APP_HOST'].split(',')

    config.action_mailer.raise_delivery_errors = ENV['MAIL_ENABLE'].to_s == 'true'
    if ENV['MAIL_ENABLE'].to_s == 'true'
      config.action_mailer.delivery_method = ENV.fetch('MAIL_METHOD') { :smtp }
      config.action_mailer.default_url_options = { host: ENV.fetch('APP_HOST') { 'localhost' } }
      config.action_mailer.smtp_settings = {
        :address              => ENV.fetch('MAIL_ADDRESS') { nil },
        :port                 => ENV.fetch('MAIL_PORT') { 587 },
        :domain               => ENV.fetch('MAIL_DOMAIN') { nil },
        :user_name            => ENV.fetch('MAIL_USERNAME') { nil },
        :password             => ENV.fetch('MAIL_PASSWORD') { nil },
        :authentication       => ENV.fetch('MAIL_AUTHENTICATION') { :plain },
        :enable_starttls_auto => true
      }
    end
  end
end
