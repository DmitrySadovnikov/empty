require_relative '../../spec_helper'

describe Transfers::Create do
  subject { described_class.call(user, params) }

  let(:user) { create(:user) }
  let(:torrent_post) { create(:torrent_post) }
  let(:params) { { torrent_post_id: torrent_post.id } }

  before do
    stub_transmission_rpc_request(id: 1)
  end

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

  it 'creates TorrentEntity with correct attributes' do
    subject
    expect(TorrentEntity.last).to have_attributes(
      transmission_id: 1,
      torrent_post: torrent_post,
      status: 'downloading'
    )
  end
end
