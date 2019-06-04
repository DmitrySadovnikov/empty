ENV['SINATRA_ENV'] ||= 'development'

require 'dotenv'
Dotenv.load(".env.#{ENV['SINATRA_ENV']}")

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require './app/controllers/application_controller'
require_all 'app'
