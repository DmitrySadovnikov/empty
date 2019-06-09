module TorrentEntities
  class CheckAllDownloadingWorker
    include Sidekiq::Worker

    sidekiq_options lock: :until_executed, on_conflict: :log, queue: :default

    def perform
      TorrentEntity.status_downloading.find_each do |torrent_entity|
        CheckDownloading.call(torrent_entity)
      end
    end
  end
end
