# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths += [Rails.root.join('app')]

    config.generators do |g|
      g.test_framework :rspec,
                       controller_specs: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end

    config.action_cable.disable_request_forgery_protection = false
    config.action_cable.mount_path = '/cable'
  end
end
