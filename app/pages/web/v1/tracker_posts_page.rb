module Web
  module V1
    class TrackerPostsPage < Tram::Page
      option :search
      section :collection

      def collection
        Trackers::Rutracker::Search.call(search)[1]
      end
    end
  end
end
