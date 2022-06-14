source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "rails", "~> 7.0.2", ">= 7.0.2.2"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "bcrypt", "~> 3.1.7"
gem 'omniauth-identity'
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem "factory_bot_rails"
  gem 'faker', '~> 2.20'
  gem "pry-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem 'jquery-rails', '~> 4.4'
gem 'bulma-rails', '~> 0.9.3'
gem 'i18n', '~> 1.10'
