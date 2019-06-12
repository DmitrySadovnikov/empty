class TorrentEntitiesController < ApplicationController
  get '/torrent_entities' do
    erb :'torrent_entities/index', {}, torrent_entities: current_user.torrent_entities
  end

  get '/torrent_entities/new' do
    erb :'torrent_entities/new'
  end

  get '/torrent_entities/search' do
    erb :'torrent_entities/search'
  end

  post '/torrent_entities' do
    TorrentEntities::Download.call(current_user, params[:magnet_link])
    redirect '/torrent_entities'
  end

  post '/torrent_entities/search' do
    content_type 'application/json'
    { data: Trackers::Rutracker::Search.call(params[:search]).last }.to_json
  end
end
