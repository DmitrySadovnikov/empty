ENV['SINATRA_ENV'] = 'test'

require './config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'
require 'webmock/rspec'
require 'sidekiq/testing'

require_all 'spec/support'

if ActiveRecord::MigrationContext.new('db/migrate').needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  config.include Gen
  config.include SidekiqHelper
  config.include TransmissionHelper
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) { FactoryBot.find_definitions }

  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'default'
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.app = app
