source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'rails', '~> 5.2.1', '>= 5.2.1.1'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'pg'
gem 'puma', '~> 3.11'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Ruby's STDLIB URI implementation sucks
gem 'addressable'

# Additional parsing
gem 'nokogiri'

# Domain parsing
gem 'public_suffix'

gem 'memcached'

group :development do
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
end
