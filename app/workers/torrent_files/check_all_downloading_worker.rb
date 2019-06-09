module TorrentFiles
  class CheckAllDownloadingWorker
    include Sidekiq::Worker

    sidekiq_options lock: :until_executed, on_conflict: :log, queue: :default

    def perform
      TorrentFile.status_downloading.find_each do |torrent_file|
        CheckDownloading.call(torrent_file)
      end
    end
  end
end
