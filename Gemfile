source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'rails', '~> 5.2.3'
gem 'pg'
gem 'puma', '~> 3.11'

# Use CoffeeScript for .coffee assets and views
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'therubyracer'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Ruby's STDLIB URI implementation sucks
gem 'addressable'

# Additional parsing
gem 'nokogiri'

# Domain parsing
gem 'public_suffix'

gem 'memcached'

# Conversion of strings to regex
gem 'to_regexp'

gem 'active_record_union'

gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'

gem 'httparty'

group :development do
  gem 'pry'
  gem 'byebug'
  gem 'pry-byebug'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rb-readline'

  # Database annotations
  gem 'annotate'

  gem 'rubocop'

  # Process launcher
  gem 'foreman'

	# Deployment
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'

  # Live reloading
  gem 'guard'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'rack-livereload'
  gem 'rb-fsevent', require: false
end
