ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'
require 'devise'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include Devise::TestHelpers, type: :controller
  DatabaseCleaner.strategy = :truncation

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    FactoryGirl.lint
    config.before(:each) do
      DatabaseCleaner.clean
    end
    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

def create_user
  User.create(strava_token: ENV['STRAVA_ACCESS_TOKEN'],
    beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'],
    password: 'foo00001', email: 'foo@example.com')
end

def create_goal_integration(user)
  GoalIntegration.create(user_id: user.id, unit: 'miles',
    goal_title: ENV['SAMPLE_BEEMINDER_GOAL_TITLE'], activity_type: 'run')
end