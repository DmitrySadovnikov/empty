module Web
  module V1
    class TransfersPage < Tram::Page
      param :user
      section :data

      def data
        relation.map { |resource| TransferPage.new(resource).to_h }
      end

      private

      def relation
        @relation ||=
          user.transfers.includes(:torrent_entity, :cloud_entities).order(:created_at)
      end
    end
  end
end
