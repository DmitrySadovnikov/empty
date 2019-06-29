module Web
  module V1
    class TorrentPostsController < Sinatra::Base
      get '/web/v1/torrent_posts/search' do
        content_type 'application/json'
        _, posts = Providers::Rutracker::Search.call(params[:search])
        TorrentPostsPage.new(posts).to_h.to_json
      end
    end
  end
end
