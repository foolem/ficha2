require_relative 'boot'

require 'roo'
require 'roo-xls'
require 'htmltoword'
require 'rails/all'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ficha2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = "pt-BR"

    config.active_record.time_zone_aware_types = [:datetime, :time]


    end

end
