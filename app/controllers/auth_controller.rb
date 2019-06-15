class AuthController < ApplicationController
  get '/auth' do
    erb :'auth/index'
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
    redirect '/transfers/new'
  end
end
