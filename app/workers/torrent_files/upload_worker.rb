module TorrentFiles
  class UploadWorker
    include Sidekiq::Worker

    sidekiq_options lock: :until_executed, on_conflict: :log, queue: :default

    def perform(torrent_file_id)
      torrent_file = TorrentFile.find_by(id: torrent_file_id)
      return unless torrent_file

      Upload.call(torrent_file)
    end
  end
end
