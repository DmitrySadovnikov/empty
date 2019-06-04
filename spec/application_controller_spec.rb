require_relative 'spec_helper'

def app
  ApplicationController
end

describe ApplicationController do
  it 'returns 200' do
    get '/'
    expect(last_response.status).to eq(200)
  end

  it 'responds with a welcome message' do
    get '/'
    expect(last_response.body).to include('Welcome to the Sinatra Template!')
  end
end
