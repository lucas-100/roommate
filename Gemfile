# Edit this Gemfile to bundle your application's dependencies.
source "https://rubygems.org"


gem "rails", "3.2.16"
gem "jquery-rails"

## Bundle edge rails:
# gem "rails", :git => "git://github.com/rails/rails.git"

# ActiveRecord requires a database adapter. By default,
# Rails has selected sqlite3.
# gem "sqlite3-ruby", :require => "sqlite3", :group => :development
# gem "pg", :group => :production

gem "bundler"
gem "coffee-rails", "~> 3.2.1"
gem "sass-rails", "~> 3.2.3"
gem "haml"

gem "thin"
gem "pg"
gem "newrelic_rpm"
gem "uglifier", ">= 1.0.3"

## Bundle the gems you use:
# gem "bj"
# gem "hpricot", "0.6"
# gem "aws-s3", :require => "aws/s3"

gem "money", "~> 6.0.0"
gem "money-rails", "~> 0.9.0"
gem 'json', '~> 1.7.7'

gem "authlogic"
gem "bcrypt-ruby"

group :cucumber, :test, :development do
  gem 'capybara'
  gem 'database_cleaner'

  gem 'rspec-rails', '>= 2.0.0'
  gem 'spork'
  gem 'webrat'
end

group :development do
  gem 'sqlite3'
end

group :cucumber, :test do
  gem 'cucumber-rails'
end

## Bundle gems used only in certain environments:
# gem "rspec", :group => :test
# group :test do
#   gem "webrat"
# end
