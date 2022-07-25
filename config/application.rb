require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

key_file = File.join "config", "master.key"
ENV["RAILS_MASTER_KEY"] = File.read key_file if File.exist? key_file

module Inka
  class Application < Rails::Application
    config.i18n.default_locale = "pt-BR"
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.generators { |g| g.test_framework :rspec, request_specs: false, routing_specs: false, helper_specs: true, controller_specs: true, view_specs: false }
    config.generators.test_framework = :rspec

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("app", "models", "stock_types")
    config.autoload_paths << Rails.root.join("lib")
  end
end
