module TorrentEntities
  class Download < ApplicationService
    param :transfer
    param :torrent_post

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
      Transmission::Model::Torrent.add(arguments: { filename: torrent_post.magnet_link })
    rescue DuplicateTorrentError => _
      nil
    end

    def torrent_entity
      @torrent_entity ||= TorrentEntity.new(
        transfer: transfer,
        torrent_post: torrent_post,
        status: :downloading
      )
    end
  end
end
