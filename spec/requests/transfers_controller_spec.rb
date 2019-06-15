require_relative '../spec_helper'

describe TransfersController do
  describe 'GET /transfers' do
    subject { get '/transfers' }

    let!(:torrent_entity) { create(:torrent_entity) }

    it 'returns 200' do
      subject
      expect(last_response.status).to eq(200)
    end

    it 'responds with a welcome message' do
      subject
      expect(last_response.body).to include(torrent_entity.name)
    end
  end
end
