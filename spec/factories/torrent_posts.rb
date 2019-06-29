FactoryBot.define do
  factory :torrent_post do
    magnet_link { Gen.random_magnet_link }
    outer_id { rand(1..100) }
    provider { TorrentPost.providers.keys.sample }
    image_url { Faker::Internet.url }
    title { Faker::Lorem.word }
    body { Faker::Lorem.sentence }
  end
end
