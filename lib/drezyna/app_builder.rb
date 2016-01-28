module Drezyna 
  class AppBuilder < Rails::AppBuilder

    include Drezyna::ActionHelpers

    def readme
      template 'README.md.erb', 'README.md'
    end

    def gitignore
      template 'gitignore.erb', '.gitignore'
    end

    def gemfile
      template 'Gemfile.erb', 'Gemfile'
    end

    def use_postgres_config_template
      template 'database.yml.erb', 'config/database.yml', force: true
      template 'database.yml.erb', 'config/database.yml.example'
    end

    def create_partials_directory
      empty_directory 'app/views/shared'
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'application.scss', 'app/assets/stylesheets/application.scss'
      copy_file '_navigation.scss', 'app/assets/stylesheets/_navigation.scss'
    end

    def setup_javascripts
      remove_file 'app/assets/javascripts/application.js'
      copy_file 'application.js', 'app/assets/javascripts/application.js'
    end

    def setup_application
      remove_file 'app/controllers/application_controller.rb'
      copy_file 'application_controller.rb', 'app/controllers/application_controller.rb'
      copy_file 'registrations_controller.rb', 'app/controllers/registrations_controller.rb'
      copy_file 'users_controller.rb', 'app/controllers/users_controller.rb'
    end

    def create_application_layout
      remove_file 'app/views/layouts/application.html.erb'
      copy_file 'layout.html.erb', 'app/views/layouts/application.html.erb'
      copy_file '_navigation.html.erb', 'app/views/shared/_navigation.html.erb'
      copy_file '_messages.html.erb', 'app/views/shared/_messages.html.erb'
    end

    def create_pryrc
      copy_file 'pryrc.rb', '.pryrc'
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def setup_routes
      copy_file 'routes.rb.erb', 'config/routes.rb', force: true
    end

    def raise_on_unpermitted_parameters
      configure_environment 'development',
        'config.action_controller.action_on_unpermitted_parameters = :raise'
    end

    def configure_generators
      config = <<-RUBY
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.javascripts false
      generate.test_framework :rspec
      generate.view_specs false
    end
      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_i18n_logger
      configure_environment 'development',
                            "# I18n debug\n  I18nLogger = ActiveSupport::" \
                            "Logger.new(Rails.root.join('log/i18n.log'))"
    end

    def setup_devise
      generate 'devise:install'
      generate 'controller', 'home index'
      generate 'devise', options[:devise_model]
    end

    def setup_simple_form
      generate 'simple_form:install'
    end

    def init_git
      run 'git init'
    end

    def setup_identities
      replace_in_file "app/models/user.rb",
                      /end\Z/,
                      <<-RUBY

  has_many :identities, dependent: :destroy

#{oauth_methods}
end
RUBY

      generate :model, "identity user:references provider:string uid:string timestamps"

      copy_file 'identity.rb', 'app/models/identity.rb', force: true

      make_user_omniauthable
    end
  end
end
