require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module ApiSample
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    #config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # For Grape
    #config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    #config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
    #config.middleware.use(Rack::Config) do |env|
    #env['api.tilt.root'] = Rails.root.join 'app', 'views', 'api'
    #end
  end
end


module AtonePractice
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # to auto load lib/ directory
    config.autoload_paths += %W(#{config.root}/lib)


    #config.i18n.default_locale = :ja
    #config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
 
    # app/api以下のrbファイルをautoload
    #config.paths.add File.join('app', 'apis'), glob: File.join('**', '*.rb')
    #config.autoload_paths += Dir[Rails.root.join('app', 'apis', '*')]

    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: false

      # Railsジェネレータがfactory_bot用のファイルを生成するのを無効化
      #g.factory_bot false

      # ファクトリファイルの置き場を変更
      #g.factory_bot dir: 'custom/dir/for/factories'
    end

  end
end
