require_relative '../../spec_helper'

describe TorrentEntities::Download do
  subject { described_class.call(transfer, torrent_post) }

  let(:transfer) { create(:transfer) }
  let(:torrent_post) { create(:torrent_post) }

  before do
    stub_transmission_rpc_request(id: 1)
  end

  it 'creates TorrentEntity' do
    expect { subject }.to change { TorrentEntity.count }.by(1)
  end

  it 'creates TorrentEntity with correct attributes' do
    subject
    expect(TorrentEntity.last).to have_attributes(transmission_id: 1)
  end

  it 'returns correct result' do
    expect(subject).to eq([:ok, TorrentEntity.last])
  end
end
