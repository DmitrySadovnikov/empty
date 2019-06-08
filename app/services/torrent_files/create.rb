module TorrentFiles
  class Create < ApplicationService
    param :magnet_link

    def call
      return [:invalid, torrent_file] unless torrent_file.valid?

      torrent = Transmission::Model::Torrent.add arguments: { filename: magnet_link }
      torrent_file.transmission_id = torrent.id
      torrent_file.save!
      [:ok, torrent_file]
    end

    private

    def torrent_file
      @torrent_file ||= TorrentFile.new(
        magnet_link: magnet_link,
        status: :pending
      )
    end
  end
end
