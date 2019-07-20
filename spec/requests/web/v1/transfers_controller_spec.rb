require './spec/spec_helper'

describe Web::V1::TransfersController do
  describe 'GET /web/v1/transfers' do
    subject { get '/web/v1/transfers' }

    let(:user) { create(:user) }
    let(:transfer) { create(:transfer, user: user) }
    let(:torrent_post) { create(:torrent_post, torrent_size: 3_460_300) }
    let!(:cloud_entity) { create(:cloud_entity, :kind_file, transfer: transfer) }
    let!(:torrent_entity) do
      create(:torrent_entity, transfer: transfer, torrent_post: torrent_post)
    end

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
            status: transfer.status,
            created_at: transfer.created_at,
            torrent_entity: {
              id: torrent_entity.id,
              name: torrent_entity.name,
              status: torrent_entity.status,
              created_at: torrent_entity.created_at
            },
            torrent_post: {
              id: torrent_post.id,
              provider: torrent_post.provider,
              outer_id: torrent_post.outer_id,
              image_url: torrent_post.image_url,
              magnet_link: torrent_post.magnet_link,
              title: torrent_post.title,
              body: torrent_post.body,
              torrent_size: '3.3 MB',
              link: "https://rutracker.org/forum/viewtopic.php?t=#{torrent_post.outer_id}"
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
    subject { post '/web/v1/transfers', params.to_json }

    let(:user) { create(:user) }
    let(:created_transfer) { Transfer.last }
    let(:created_torrent_entity) { TorrentEntity.last }

    before do
      allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
      stub_transmission_rpc_request
    end

    shared_context 'common cases' do
      it 'returns 200' do
        subject
        expect(last_response.status).to eq(200)
      end

      it 'creates Transfer' do
        expect { subject }.to change { Transfer.count }.by(1)
      end

      it 'creates TorrentEntity' do
        expect { subject }.to change { TorrentEntity.count }.by(1)
      end

      context 'without current_user' do
        let(:user) { nil }

        it 'returns 401' do
          subject
          expect(last_response.status).to eq(401)
        end
      end
    end

    context 'with magnet_link' do
      let(:params) { { magnet_link: Gen.random_magnet_link } }

      it_behaves_like 'common cases'

      it 'returns correct json' do
        subject
        expectation = {
          id: created_transfer.id,
          status: created_transfer.status,
          created_at: created_transfer.created_at,
          torrent_entity: {
            id: created_torrent_entity.id,
            name: created_torrent_entity.name,
            status: created_torrent_entity.status,
            created_at: created_torrent_entity.created_at
          },
          torrent_post: nil,
          cloud_entities: []
        }.as_json
        expect(JSON.parse(last_response.body)).to eq(expectation)
      end
    end

    context 'with torrent_file' do
      let(:torrent_file) { create(:torrent_file) }
      let(:params) { { torrent_file_id: torrent_file.id } }

      it_behaves_like 'common cases'

      it 'returns correct json' do
        subject
        expectation = {
          id: created_transfer.id,
          status: created_transfer.status,
          created_at: created_transfer.created_at,
          torrent_entity: {
            id: created_torrent_entity.id,
            name: created_torrent_entity.name,
            status: created_torrent_entity.status,
            created_at: created_torrent_entity.created_at
          },
          torrent_post: nil,
          cloud_entities: []
        }.as_json
        expect(JSON.parse(last_response.body)).to eq(expectation)
      end
    end

    context 'with torrent_post' do
      let(:torrent_post) { create(:torrent_post, torrent_size: 3_460_300) }
      let(:params) { { torrent_post_id: torrent_post.id } }

      it_behaves_like 'common cases'

      it 'returns correct json' do
        subject
        expectation = {
          id: created_transfer.id,
          status: created_transfer.status,
          created_at: created_transfer.created_at,
          torrent_entity: {
            id: created_torrent_entity.id,
            name: created_torrent_entity.name,
            status: created_torrent_entity.status,
            created_at: created_torrent_entity.created_at
          },
          torrent_post: {
            id: torrent_post.id,
            provider: torrent_post.provider,
            outer_id: torrent_post.outer_id,
            image_url: torrent_post.image_url,
            magnet_link: torrent_post.magnet_link,
            title: torrent_post.title,
            body: torrent_post.body,
            torrent_size: '3.3 MB',
            link: "https://rutracker.org/forum/viewtopic.php?t=#{torrent_post.outer_id}"
          },
          cloud_entities: []
        }.as_json
        expect(JSON.parse(last_response.body)).to eq(expectation)
      end
    end
  end
end
