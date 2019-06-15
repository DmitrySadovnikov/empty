module Web
  module V1
    class TransferPage < Tram::Page
      param :resource
      section :id, value: -> { resource.id }
      section :created_at, value: -> { resource.created_at }
      section :torrent_entity, value: -> { TorrentEntityPage.new(resource.torrent_entity).to_h }
      section :cloud_entities

      def cloud_entities
        resource.cloud_entities.order(:created_at).map do |cloud_entity|
          CloudEntityPage.new(cloud_entity).to_h
        end
      end
    end
  end
end
