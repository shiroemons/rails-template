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
run 'bundle install --path vendor/bundle --jobs=4'
