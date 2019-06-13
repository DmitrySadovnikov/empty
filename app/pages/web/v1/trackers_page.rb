module Web
  module V1
    class TrackersPage < Tram::Page
      option :search
      section :data

      def data
        Trackers::Rutracker::Search.call(search)[1]
      end
    end
  end
end
