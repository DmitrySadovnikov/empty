module Web
  module V1
    class TorrentEntitiesPage < Tram::Page
      param :user
      section :data

      def data
        relation.map { |resource| TorrentEntityPage.new(resource).to_h }
      end

      private

      def relation
        @relation ||= user.torrent_entities
      end
    end
  end
end
