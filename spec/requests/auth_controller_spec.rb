require_relative '../spec_helper'

describe AuthController do
  describe 'GET /auth' do
    subject { get '/auth' }

    it 'returns 200' do
      subject
      expect(last_response.status).to eq(200)
    end

    it 'responds with a welcome message' do
      subject
      expect(last_response.body).to include('Google OAuth2 Example')
    end
  end
end
