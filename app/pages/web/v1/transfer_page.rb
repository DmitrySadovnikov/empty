module Web
  module V1
    class TransferPage < Tram::Page
      param :resource
      section :id, value: -> { resource.id }
      section :created_at, value: -> { resource.created_at }
      section :torrent_entity, value: -> { TorrentEntityPage.new(resource.torrent_entity).to_h }
      section :cloud_entity, value: -> { CloudEntityPage.new(resource.torrent_entity).to_h }
    end
  end
end
