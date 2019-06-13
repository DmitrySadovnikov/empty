module Web
  module V1
    class TorrentEntitiesController < ApplicationController
      get '/web/v1/torrent_entities' do
        content_type 'application/json'

        TorrentEntitiesPage.new(current_user).to_h.to_json
      end

      post '/web/v1/torrent_entities' do
        content_type 'application/json'

        _, resource = TorrentEntities::Download.call(current_user, params[:magnet_link])
        TorrentEntityPage.new(resource).to_h.to_json
      end
    end
  end
end
