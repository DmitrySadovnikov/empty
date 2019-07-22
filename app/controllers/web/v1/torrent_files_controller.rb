module Web
  module V1
    class TorrentFilesController < Sinatra::Base
      post '/web/v1/torrent_files' do
        content_type 'application/json'
        torrent_file = TorrentFile.create!(value: params[:torrent_file])
        {
          id: torrent_file.id,
          url: torrent_file.value_url
        }.to_json
      end
    end
  end
end
