require_relative '../spec_helper'

describe ApplicationController do
  subject { get '/' }

  it 'returns 200' do
    subject
    expect(last_response.status).to eq(200)
  end

  it 'responds with a welcome message' do
    subject
    expect(last_response.body).to include('Welcome to the Sinatra Template!')
  end
end
