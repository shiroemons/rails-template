# .gitignore
run 'gibo macOS Ruby Rails JetBrains > .gitignore' rescue nil
gsub_file '.gitignore', /^config\/initializers\/secret_token.rb\n/, ''
gsub_file '.gitignore', /^config\/secrets.yml\n/, ''

# Gemfile
gsub_file 'Gemfile', /gem 'turbolinks'.*/, ''

gem_group :default do
  gem 'webpacker', '~> 3.0'
  gem 'hamlit-rails'
  gem 'erb2haml'
  gem 'i18n_generators'
end

gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'annotate'
  gem 'rack-mini-profiler'
  gem 'rubocop', require: false
  gem 'dotenv-rails'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'view_source_map'
  gem 'global'
end

gem_group :development, :test do
  gem 'awesome_print', require: 'ap'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-byebug'
  gem 'pry-coolline'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

gem_group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'database_rewinder'
  gem 'webmock'
  gem 'vcr'
end

# install gems
Bundler.with_clean_env do
  run 'bundle install --path vendor/bundle --jobs=4'
end

# convert erb file to haml
rails_command 'haml:replace_erbs'

# Webpacker
rails_command 'webpacker:install'

# Generate secret key
run 'bundle exec rails secrets:setup'

# config/application.rb
application do
  %q{
    config.time_zone = 'Tokyo'

    I18n.enforce_available_locales = true
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja

    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.controller_specs true
      g.routing_specs false
      g.helper_specs false
      g.request_specs false
      g.assets false
      g.helper false
    end

    config.paths.add 'lib', eager_load: true
  }
end

# config/environments/development.rb
insert_into_file 'config/environments/development.rb', <<RUBY, after: 'config.file_watcher = ActiveSupport::EventedFileUpdateChecker'


  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
RUBY


# setup rspec
generate 'rspec:install'

create_file '.rspec', <<EOF, force: true
--color -f d
EOF

insert_into_file 'spec/spec_helper.rb', <<RUBY, before: 'RSpec.configure do |config|'
require 'factory_girl_rails'
require 'vcr'
RUBY

insert_into_file 'spec/spec_helper.rb', <<RUBY, after: 'RSpec.configure do |config|'

  config.before :suite do
    DatabaseRewinder.clean_all
  end

  config.after :each do
    DatabaseRewinder.clean
  end

  config.before :all do
    FactoryGirl.reload
    FactoryGirl.factories.clear
    FactoryGirl.sequences.clear
    FactoryGirl.find_definitions
  end

  config.include FactoryGirl::Syntax::Methods

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr'
    c.hook_into :webmock
    c.allow_http_connections_when_no_cassette = true
  end
RUBY

# set up spring
run 'bundle exec spring binstub --all'
