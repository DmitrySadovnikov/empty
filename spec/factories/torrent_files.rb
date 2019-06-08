FactoryBot.define do
  factory :torrent_file do
    magnet { SecureRandom.uuid }
    transmission_id { rand(1..100) }
  end
end
