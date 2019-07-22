require './config/environment'

class App < Sinatra::Base
  use Rack::Session::Cookie, secret: ENV['RACK_COOKIE_SECRET']
  use Rack::Cors do |config|
    config.allow do |allow|
      allow.origins '*'
      allow.resource '*', headers: :any, methods: :any
    end
  end
  use OmniAuth::Builder do
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET'],
             access_type: 'offline',
             prompt: 'consent',
             provider_ignores_state: true,
             scope: 'email,profile,drive.file'
  end
  use ApplicationController
  use AuthController
  use TransfersController
  use Web::V1::TorrentFilesController
  use Web::V1::TorrentPostsController
  use Web::V1::TransfersController
end
