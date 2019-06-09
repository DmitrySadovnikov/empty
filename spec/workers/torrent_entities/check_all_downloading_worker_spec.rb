require_relative '../../spec_helper'

describe TorrentEntities::CheckAllDownloadingWorker do
  subject { described_class.new.perform }

  let!(:torrent_entity) { create(:torrent_entity, status: :downloading) }

  before do
    stub_transmission_rpc_request
  end

  it_behaves_like 'should present at the cron schedule'

  it 'calls TorrentEntities::Check' do
    expect(TorrentEntities::CheckDownloading).to receive(:call)
    subject
  end

  it 'changes torrent_entity status' do
    expect { subject }.to change { torrent_entity.reload.status }.to('downloaded')
  end
end
