source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'countries', '~> 4.0', '>= 4.0.1', require: 'countries/global'
gem 'shrine'
gem 'influxdb-client'
gem 'influxdb-client-apis'
gem 'pry'
gem 'pry-inline'
gem 'pry-rails'
gem 'dotenv-rails'
gem 'sidekiq'
gem 'money-rails'
gem 'dry-struct'
gem 'dry-validation'
gem 'graphql'
gem 'graphql-rails_logger', '~> 1.2', '>= 1.2.3'
gem 'faraday', '~> 1.4', '>= 1.4.2'
gem 'faraday_middleware'
gem 'selenium-webdriver', '~> 4.0.0.alpha4'
gem 'search_object'
gem 'sidekiq-scheduler'
gem 'search_object_graphql'
gem "mustache", "~> 1.0"
gem 'down'
gem 'pdf-reader', '~> 2.4', '>= 2.4.1'

# Bundle edge Rails instead: 
gem 'rails', github: 'rails/rails', branch: MASTER = 'main'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', '~> 1.6', '>= 1.6.1'
  gem 'rubocop-rails', '~> 2.6'
  gem 'rubocop-rspec', require: false
  gem 'execution_time'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'graphiql-rails'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'webmock', '~> 3.11'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]