require_relative '../../spec_helper'

describe Transfers::Create do
  subject { described_class.call(user, params) }

  let(:user) { create(:user) }

  before do
    stub_transmission_rpc_request(id: 1)
  end

  context 'with torrent_post' do
    let(:params) { { torrent_post_id: torrent_post.id } }
    let(:torrent_post) { create(:torrent_post) }

    it 'creates Transfer' do
      expect { subject }.to change { Transfer.count }.by(1)
    end

    it 'creates TorrentEntity' do
      expect { subject }.to change { TorrentEntity.count }.by(1)
    end

    it 'creates Transfer with correct attributes' do
      subject
      expect(Transfer.last).to have_attributes(
        user: user,
        status: 'downloading'
      )
    end
  end

  context 'with torrent_file' do
    let(:params) { { torrent_file_id: torrent_file.id } }
    let(:torrent_file) { create(:torrent_file) }

    it 'creates Transfer' do
      expect { subject }.to change { Transfer.count }.by(1)
    end

    it 'creates TorrentEntity' do
      expect { subject }.to change { TorrentEntity.count }.by(1)
    end

    it 'creates Transfer with correct attributes' do
      subject
      expect(Transfer.last).to have_attributes(
        user: user,
        status: 'downloading'
      )
    end
  end

  context 'with magnet_link' do
    let(:params) { { magnet_link: magnet_link } }
    let(:magnet_link) { Gen.random_magnet_link }

    it 'creates Transfer' do
      expect { subject }.to change { Transfer.count }.by(1)
    end

    it 'creates TorrentEntity' do
      expect { subject }.to change { TorrentEntity.count }.by(1)
    end

    it 'creates Transfer with correct attributes' do
      subject
      expect(Transfer.last).to have_attributes(
        user: user,
        status: 'downloading'
      )
    end
  end
end
