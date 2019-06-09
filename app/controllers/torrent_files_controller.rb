class TorrentFilesController < ApplicationController
  get '/torrent_files/new' do
    erb :'torrent_files/new'
  end

  post '/torrent_files' do
    code, torrent_file = TorrentFiles::Download.call(current_user, params[:magnet_link])
    content_type 'application/json'
    { code: code, torrent_file: torrent_file }.to_json
  end
end
