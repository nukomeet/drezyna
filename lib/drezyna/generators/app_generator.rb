require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Drezyna
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :devise_model, type: :string, aliases: '-M', default: 'User',
      desc: 'Name of devise model to generate'

    class_option :skip_test_unit, type: :boolean, aliases: '-T', default: true,
      desc: 'Skip Test::Unit files'

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
      desc: "Don't run bundle install"

    def finish_template
      invoke :custom
      super
    end

    def custom
      say 'Setting up database'
      build :use_postgres_config_template
      build :create_database

      say 'Setting up the development environment'
      build :configure_generators
      build :raise_on_unpermitted_parameters
      build :configure_i18n_logger

      build :create_partials_directory
      build :create_application_layout
      build :create_pryrc

      run "bundle install"

      build :setup_application

      build :setup_stylesheets
      build :setup_javascripts

      say 'Setting up devise'
      build :setup_devise

      say 'Setting up SimpleForm'
      build :setup_simple_form

      build :setup_routes

      say 'Initializing git'
      build :setup_gitignore
      build :init_git
    end

    protected

    def get_builder_class
      Drezyna::AppBuilder
    end
  end
end
