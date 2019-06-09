class AuthController < ApplicationController
  get '/auth' do
    erb :auth
  end

  post '/auth/:provider/callback' do
    process_callback
  end

  get '/auth/:provider/callback' do
    process_callback
  end

  private

  def process_callback
    Users::Create.call(request.env['omniauth.auth'])
    # content_type 'application/json'
    # request.env['omniauth.auth'].to_json
    redirect '/torrent_files/new'
  end
end
