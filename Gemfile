# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0.0'
# Use Barby for barcode generate
gem 'barby'
gem 'chunky_png'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.5'
# Use Puma as the app server
gem 'puma', '~> 6.4'
# Use SCSS for stylesheets
gem 'faker'
gem 'sassc-rails'
# Use Terser as compressor for JavaScript assets (replaces uglifier)
gem 'terser'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.12'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
gem 'lazyload-rails'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.18.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # gem 'rubocop', require: false
  # gem 'rubocop-rails', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.8'
  gem 'web-console', '~> 4.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring' # Removed for Rails 8 compatibility
  # gem 'spring-watcher-listen', '~> 2.0.0' # Removed for Rails 8 compatibility
  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano-bundler'
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'devise', '~> 4.9'
# devise_token_auth is incompatible with Rails 8 - will need to replace with devise-jwt or similar
# gem 'devise_token_auth'
gem 'cancancan', '~> 3.6' # Replaces cancan
gem 'friendly_id', '~> 5.5'
#
# gem 'sitemap_generator'

gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'carrierwave', '~> 3.0'
gem 'rmagick', '~> 5.3'
# ckeditor gem is unmaintained for Rails 8 - will need to replace with ActionText or CKEditor 5
# gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'annotate'
gem 'bootstrap4-kaminari-views'
gem 'kaminari', '~> 1.2'
gem 'mini_magick'
gem 'paypal-sdk-merchant'
gem 'select2-rails' # , '~> 3.5.9.1'
gem 'social-share-button'

gem 'importmap-rails'
gem 'rack-cors', require: 'rack/cors'
