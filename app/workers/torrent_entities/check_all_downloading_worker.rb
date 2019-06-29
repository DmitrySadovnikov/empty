module TorrentEntities
  class CheckAllDownloadingWorker
    include Sidekiq::Worker

    sidekiq_options lock: :until_executed, on_conflict: :log, queue: :default

    def perform
      TorrentEntity.status_downloading.find_each do |torrent_entity|
        CheckDownloadingWorker.perform_async(torrent_entity.id)
      end
    end
  end
end
