require_relative '../../spec_helper'

describe TorrentEntities::Download do
  subject { described_class.call(user, magnet_link) }

  let(:user) { create(:user) }
  let(:magnet_link) { 'magnet:?xt=urn:btih:14ea8deecc33e2750f9c9b0eab70f409f4c362e4' }

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

  context 'with invalid magnet_link ' do
    let(:magnet_link) { SecureRandom.uuid }

    it 'returns correct result' do
      expect(subject).to match_array([:invalid, kind_of(TorrentEntity)])
    end
  end
end
