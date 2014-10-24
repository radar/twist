# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'

DatabaseCleaner.orm = :mongoid

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before do
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
end

Dir["spec/support/**/*"].each {|f| require File.expand_path(f)}
