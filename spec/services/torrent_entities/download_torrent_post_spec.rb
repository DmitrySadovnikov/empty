require_relative '../../spec_helper'

describe TorrentEntities::DownloadTorrentPost do
  subject { described_class.call(transfer, torrent_post) }

  let(:transfer) { create(:transfer) }
  let(:torrent_post) { create(:torrent_post) }
  let(:created_torrent_entity) { TorrentEntity.last }

  before do
    stub_transmission_rpc_request(id: 1)
  end

  it 'creates TorrentEntity' do
    expect { subject }.to change { TorrentEntity.count }.by(1)
  end

  it 'creates TorrentEntity with correct attributes' do
    subject
    expect(created_torrent_entity).to have_attributes(
      transmission_id: 1,
      trigger: 'torrent_post',
      torrent_post: torrent_post,
      magnet_link: torrent_post.magnet_link
    )
  end

  it 'returns correct result' do
    expect(subject).to eq([:ok, created_torrent_entity])
  end
end
