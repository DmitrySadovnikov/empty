class TorrentEntitiesController < ApplicationController
  get '/torrent_entities' do
    erb :'transfers/index', {}, transfers: current_user.transfers
  end

  get '/torrent_entities/new' do
    erb :'transfers/new'
  end

  get '/torrent_entities/search' do
    erb :'transfers/search'
  end

  post '/torrent_entities' do
    Transfers::Create.call(current_user, params)
    redirect '/torrent_entities'
  end

  post '/torrent_entities/search' do
    content_type 'application/json'
    { data: Trackers::Rutracker::Search.call(params[:search]).last }.to_json
  end
end
