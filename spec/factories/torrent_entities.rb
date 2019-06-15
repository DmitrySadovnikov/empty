FactoryBot.define do
  factory :torrent_entity do
    transfer
    magnet_link { 'magnet:?xt=urn:btih:14ea8deecc33e2750f9c9b0eab70f409f4c362e4' }
    transmission_id { rand(1..100) }
    name { SecureRandom.uuid }
  end
end
