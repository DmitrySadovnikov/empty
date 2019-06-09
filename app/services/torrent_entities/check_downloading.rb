module TorrentEntities
  class CheckDownloading < ApplicationService
    param :torrent_entity

    def call
      torrent = Transmission::Model::Torrent.find(torrent_entity.transmission_id)

      if torrent.finished?
        torrent_entity.name = torrent.name
        torrent_entity.status_downloaded!
        UploadWorker.perform_async(torrent_entity.id)
      end

      [:ok, torrent_entity]
    end
  end
end
