# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'


gem "rails", "3.2.12"

## Bundle edge rails:
# gem "rails", :git => "git://github.com/rails/rails.git"

# ActiveRecord requires a database adapter. By default,
# Rails has selected sqlite3.
# gem "sqlite3-ruby", :require => "sqlite3", :group => :development
# gem "pg", :group => :production

gem "bundler"
gem "coffee-rails", "~> 3.2.1"
gem "sass-rails", "~> 3.2.3"

gem "thin"
gem "pg"
gem "newrelic_rpm"
gem "uglifier", ">= 1.0.3"

## Bundle the gems you use:
# gem "bj"
# gem "hpricot", "0.6"
# gem "aws-s3", :require => "aws/s3"

gem "money", "~> 2.1.5"
gem 'json', '~> 1.7.7'

group :cucumber, :test, :development do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec-rails', '>= 2.0.0'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  # gem 'metric_fu'
  gem 'webrat'
  gem 'newrelic_rpm'
end

group :development do
  gem 'sqlite3'
end

## Bundle gems used only in certain environments:
# gem "rspec", :group => :test
# group :test do
#   gem "webrat"
# end
