require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.storage = :file
end
