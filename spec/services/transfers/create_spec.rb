require_relative '../../spec_helper'

describe Transfers::Create do
  subject { described_class.call(user, params) }

  let(:user) { create(:user) }
  let(:params) { { magnet_link: Gen.random_magnet_link } }

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
      magnet_link: params[:magnet_link],
      status: 'downloading'
    )
  end
end
