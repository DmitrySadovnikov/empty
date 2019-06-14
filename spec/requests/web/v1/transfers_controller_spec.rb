require './spec/spec_helper'

describe Web::V1::TransfersController do
  describe 'GET /web/v1/transfers' do
    subject { get '/web/v1/transfers' }

    let(:user) { create(:user) }
    let!(:torrent_entity) { create(:torrent_entity, user: user) }

    before do
      allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
    end

    context 'without current_user' do
      let(:user) { nil }
      let(:torrent_entity) { nil }

      it 'returns 401' do
        subject
        expect(last_response.status).to eq(401)
      end
    end

    it 'returns 200' do
      subject
      expect(last_response.status).to eq(200)
    end

    it 'returns correct json' do
      subject
      expectation = {
        id: torrent_entity.id,
        name: torrent_entity.name,
        status: torrent_entity.status,
        cloud_file_url: torrent_entity.cloud_file_url,
        created_at: torrent_entity.created_at
      }.as_json
      expect(JSON.parse(last_response.body)['data'][0]).to eq(expectation)
    end
  end

  describe 'POST /web/v1/transfers' do
    subject { post '/web/v1/transfers', params }

    let(:user) { create(:user) }
    let(:created_torrent_entity) { TorrentEntity.last }
    let!(:params) do
      {
        magnet_link: 'magnet:?xt=urn:btih:14ea8deecc33e2750f9c9b0eab70f409f4c362e4'
      }
    end

    before do
      allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
      stub_transmission_rpc_request
    end

    context 'without current_user' do
      let(:user) { nil }

      it 'returns 401' do
        subject
        expect(last_response.status).to eq(401)
      end
    end

    it 'returns 200' do
      subject
      expect(last_response.status).to eq(200)
    end

    it 'creates torrent_entity' do
      expect { subject }.to change { TorrentEntity.count }.by(1)
    end

    it 'returns correct json' do
      subject
      expectation = {
        id: created_torrent_entity.id,
        name: created_torrent_entity.name,
        status: created_torrent_entity.status,
        cloud_file_url: created_torrent_entity.cloud_file_url,
        created_at: created_torrent_entity.created_at
      }.as_json
      expect(JSON.parse(last_response.body)).to eq(expectation)
    end
  end
end
