require_relative '../../spec_helper'

describe TorrentEntities::DownloadMagnetLink do
  subject { described_class.call(transfer, magnet_link) }

  let(:transfer) { create(:transfer) }
  let(:magnet_link) { Gen.random_magnet_link }
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
      trigger: 'magnet_link',
      magnet_link: magnet_link
    )
  end

  it 'returns correct result' do
    expect(subject).to eq([:ok, created_torrent_entity])
  end
end
