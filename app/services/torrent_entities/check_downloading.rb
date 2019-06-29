module TorrentEntities
  class CheckDownloading < ApplicationService
    param :torrent_entity
    option :transfer, default: -> { torrent_entity.transfer }

    def call
      torrent = Transmission::Model::Torrent.find(torrent_entity.transmission_id)

      if torrent.finished?
        torrent_entity.name = torrent.name
        ActiveRecord::Base.transaction do
          torrent_entity.status_downloaded!
          transfer.status_downloaded!
        end
        Transfers::PrepareToUploadWorker.perform_async(transfer.id)
      end

      [:ok, torrent_entity]
    end
  end
end
