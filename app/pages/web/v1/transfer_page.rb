module Web
  module V1
    class TransferPage < Tram::Page
      param :resource
      option :db_cloud_entities, default: -> { resource.cloud_entities.order(:created_at) }
      option :db_torrent_entity, default: -> { resource.torrent_entity }
      option :db_torrent_post, default: -> { resource.torrent_entity.torrent_post }

      section :id, value: -> { resource.id }
      section :status, value: -> { resource.status }
      section :created_at, value: -> { resource.created_at }
      section :torrent_entity, value: -> { TorrentEntityPage.new(db_torrent_entity).to_h }
      section :torrent_post,
              value: -> { TorrentPostPage.new(db_torrent_post).to_h if db_torrent_post }
      section :cloud_entities,
              value: -> { db_cloud_entities.map { |e| CloudEntityPage.new(e).to_h } }
    end
  end
end
