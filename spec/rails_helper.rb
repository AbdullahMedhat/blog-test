ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'rspec/retry'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # config.include Capybara::DSL
  config.include FactoryBot::Syntax::Methods


  config.after(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:all) do
    DatabaseCleaner.clean
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.verbose_retry = true
end
