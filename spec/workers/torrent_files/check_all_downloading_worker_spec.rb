require_relative '../../spec_helper'

describe TorrentFiles::CheckAllDownloadingWorker do
  subject { described_class.new.perform }

  let!(:torrent_file) { create(:torrent_file, status: :downloading) }

  before do
    stub_transmission_rpc_request
  end

  it_behaves_like 'should present at the cron schedule'

  it 'calls TorrentFiles::Check' do
    expect(TorrentFiles::CheckDownloading).to receive(:call)
    subject
  end

  it 'changes torrent_file status' do
    expect { subject }.to change { torrent_file.reload.status }.to('downloaded')
  end
end
