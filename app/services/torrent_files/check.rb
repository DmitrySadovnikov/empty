module TorrentFiles
  class Check < ApplicationService
    param :torrent_file

    def call
      torrent = Transmission::Model::Torrent.find(torrent_file.transmission_id)
      torrent_file.status_downloaded! if torrent.percentDone == 1

      [:ok, torrent_file]
    end
  end
end
