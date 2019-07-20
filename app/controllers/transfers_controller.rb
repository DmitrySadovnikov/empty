class TransfersController < ApplicationController
  get '/transfers' do
    erb :'transfers/index', {}, transfers: current_user.transfers
  end

  get '/torrent_files/new' do
    erb :'torrent_files/new'
  end

  get '/transfers/new' do
    erb :'transfers/new'
  end

  get '/transfers/search' do
    erb :'transfers/search'
  end

  post '/transfers' do
    Transfers::Create.call(current_user, params)
    redirect '/transfers'
  end

  post '/transfers/search' do
    content_type 'application/json'
    { collection: Providers::Rutracker::Search.call(params[:search]).last }.to_json
  end
end
