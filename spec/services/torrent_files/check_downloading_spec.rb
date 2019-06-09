require_relative '../../spec_helper'

describe TorrentFiles::CheckDownloading do
  subject { described_class.call(torrent_file) }

  let!(:torrent_file) { create(:torrent_file, status: :downloading) }

  before do
    stub_transmission_rpc_request(name: 'name')
  end

  it 'changes torrent_file status' do
    expect { subject }.to change { torrent_file.reload.status }.to('downloaded')
  end

  it 'changes torrent_file name' do
    expect { subject }.to change { torrent_file.reload.name }.to('name')
  end

  it 'calls TorrentFiles::UploadWorker' do
    subject
    expect(TorrentFiles::UploadWorker).to have_enqueued_sidekiq_job(torrent_file.id)
  end
end
