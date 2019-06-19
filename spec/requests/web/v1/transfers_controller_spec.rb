require './spec/spec_helper'

describe Web::V1::TransfersController do
  describe 'GET /web/v1/transfers' do
    subject { get '/web/v1/transfers' }

    let(:user) { create(:user) }
    let(:transfer) { create(:transfer, user: user) }
    let!(:torrent_entity) { create(:torrent_entity, transfer: transfer) }
    let!(:cloud_entity) { create(:cloud_entity, :kind_file, transfer: transfer) }

    before do
      allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
    end

    context 'without current_user' do
      before do
        allow_any_instance_of(described_class).to receive(:current_user).and_return(nil)
      end

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
        collection: [
          {
            id: transfer.id,
            created_at: transfer.created_at,
            torrent_entity: {
              id: torrent_entity.id,
              name: torrent_entity.name,
              status: torrent_entity.status,
              created_at: torrent_entity.created_at
            },
            cloud_entities: [
              {
                id: cloud_entity.id,
                cloud_file_url: cloud_entity.cloud_file_url,
                status: cloud_entity.status,
                created_at: cloud_entity.created_at
              }
            ]
          }
        ]
      }.as_json
      expect(JSON.parse(last_response.body)).to eq(expectation)
    end
  end

  describe 'POST /web/v1/transfers' do
    subject { post '/web/v1/transfers', params }

    let(:user) { create(:user) }
    let(:created_transfer) { Transfer.last }
    let(:created_torrent_entity) { TorrentEntity.last }
    let!(:params) { { magnet_link: Gen.random_magnet_link } }

    before do
      allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
      stub_transmission_rpc_request
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
        id: created_transfer.id,
        created_at: created_transfer.created_at,
        torrent_entity: {
          id: created_torrent_entity.id,
          name: nil,
          status: 'downloading',
          created_at: created_torrent_entity.created_at
        },
        cloud_entities: []
      }.as_json
      expect(JSON.parse(last_response.body)).to eq(expectation)
    end

    context 'without current_user' do
      let(:user) { nil }

      it 'returns 401' do
        subject
        expect(last_response.status).to eq(401)
      end
    end
  end
end
