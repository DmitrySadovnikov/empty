FactoryBot.define do
  factory :torrent_entity do
    transfer
    torrent_post
    trigger { :torrent_post }
    transmission_id { rand(1..100) }
    name { SecureRandom.uuid }
  end
end
