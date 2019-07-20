module TorrentEntities
  class DownloadMagnetLink < ApplicationService
    param :transfer
    param :magnet_link

    def call
      return [:invalid, torrent_entity] unless torrent_entity.valid?

      torrent = add_torrent
      return [:no_torrent, torrent_entity] unless torrent

      torrent_entity.transmission_id = torrent.id
      ActiveRecord::Base.transaction do
        transfer.save!
        torrent_entity.save!
      end

      [:ok, torrent_entity]
    end

    private

    def add_torrent
      Transmission::Model::Torrent.add(arguments: { filename: magnet_link })
    rescue DuplicateTorrentError
      nil
    end

    def torrent_entity
      @torrent_entity ||= TorrentEntity.new(
        transfer: transfer,
        magnet_link: magnet_link,
        trigger: :magnet_link,
        status: :downloading
      )
    end
  end
end
