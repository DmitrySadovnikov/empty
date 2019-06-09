class TorrentEntitiesController < ApplicationController
  get '/torrent_entities' do
    erb :'torrent_entities/index', {}, torrent_entities: current_user.torrent_entities
  end

  get '/torrent_entities/new' do
    erb :'torrent_entities/new'
  end

  post '/torrent_entities' do
    TorrentEntities::Download.call(current_user, params[:magnet_link])
    redirect '/torrent_entities'
  end
end
