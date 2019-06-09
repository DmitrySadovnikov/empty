module TorrentFiles
  class CheckDownloading < ApplicationService
    param :torrent_file

    def call
      torrent = Transmission::Model::Torrent.find(torrent_file.transmission_id)

      if torrent.finished?
        torrent_file.name = torrent.name
        torrent_file.status_downloaded!
        UploadWorker.perform_async(torrent_file.id)
      end

      [:ok, torrent_file]
    end
  end
end
