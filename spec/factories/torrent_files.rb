FactoryBot.define do
  factory :torrent_file do
    value { File.open('spec/fixtures/files/torrent.torrent') }
  end
end
