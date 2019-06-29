module Web
  module V1
    class TorrentPostsPage < Tram::Page
      param :posts
      section :collection

      def collection
        posts.map { |resource| TorrentPostPage.new(resource).to_h }
      end
    end
  end
end
