require_relative '../../spec_helper'

describe TorrentEntities::DownloadTorrentFile do
  subject { described_class.call(transfer, torrent_file) }

  let(:transfer) { create(:transfer) }
  let(:torrent_file) { create(:torrent_file) }
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
      trigger: 'torrent_file',
      torrent_file: torrent_file
    )
  end

  it 'returns correct result' do
    expect(subject).to eq([:ok, created_torrent_entity])
  end
end
