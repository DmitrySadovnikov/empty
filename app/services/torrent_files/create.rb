module TorrentFiles
  class Create < ApplicationService
    param :magnet

    def call
      torrent = Transmission::Model::Torrent.add arguments: { filename: magnet }
      torrent_file = TorrentFile.create!(magnet: magnet,
                                         transmission_id: torrent.id,
                                         status: :pending)
      [:ok, torrent_file]
    end
  end
end
