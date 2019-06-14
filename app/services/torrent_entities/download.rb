module TorrentEntities
  class Download < ApplicationService
    param :transfer
    param :magnet_link

    def call
      return [:invalid, torrent_entity] unless torrent_entity.valid?

      torrent = Transmission::Model::Torrent.add arguments: { filename: magnet_link }
      torrent_entity.transmission_id = torrent.id
      torrent_entity.save!
      transfer.status_downloading!
      [:ok, torrent_entity]
    end

    private

    def torrent_entity
      @torrent_entity ||= TorrentEntity.new(
        transfer: transfer,
        magnet_link: magnet_link,
        status: :downloading
      )
    end
  end
end
