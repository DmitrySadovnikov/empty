require 'transmission'

Transmission::Config.set(port: ENV['TRANSMISSION_PORT'])
