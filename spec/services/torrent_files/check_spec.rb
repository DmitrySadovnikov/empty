require_relative '../../spec_helper'

describe TorrentFiles::Check do
  subject { described_class.call(torrent_file) }

  let!(:torrent_file) { create(:torrent_file, status: :pending) }

  before do
    stub_transmission_rpc_request
  end

  it 'changes torrent_file status' do
    expect { subject }.to change { torrent_file.reload.status }.to('done')
  end
end
