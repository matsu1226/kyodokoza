require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Asia/Tokyo'
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    #rails g 時の自動生成ファイルの設定
    config.generators do |g|
      g.test_framework :rspec,
                        view_specs: false,
                        helper_specs: false,
                        controller_specs: false,
                        routing_specs: false,
                        request_specs: false
    end

    # errors.full_messageの日本語化
    config.i18n.default_locale = :ja
    # errors.full_message時に表示するカラム名を別表記に設定(src/config/locates/models/ja.yml)
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    # validation error発生時のfield_with_errorsの自動挿入を禁止
    # https://yukimasablog.com/rails-field-with-errors
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
  end
end
