require_relative '../spec_helper'

describe TorrentEntitiesController do
  describe 'GET /torrent_entities' do
    subject { get '/torrent_entities' }

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
