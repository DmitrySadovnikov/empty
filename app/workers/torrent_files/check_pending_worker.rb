module TorrentFiles
  class CheckPendingWorker
    include Sidekiq::Worker

    sidekiq_options lock: :until_executed, on_conflict: :log, queue: :default

    def perform
      TorrentFile.status_pending.find_each { |torrent_file| Check.call(torrent_file) }
    end
  end
end
