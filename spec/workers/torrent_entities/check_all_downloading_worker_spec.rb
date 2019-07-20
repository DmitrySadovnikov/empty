require_relative '../../spec_helper'

describe TorrentEntities::CheckAllDownloadingWorker do
  subject { described_class.new.perform }

  let!(:torrent_entity) { create(:torrent_entity, status: :downloading, name: 'test.pdf') }

  before do
    stub_transmission_rpc_request(name: 'test.pdf')
    allow(Transfers::PrepareToUploadWorker).to receive(:perform_async).and_return(true)
  end

  it_behaves_like 'should present at the cron schedule'

  it 'calls TorrentEntities::CheckDownloadingWorker' do
    expect(TorrentEntities::CheckDownloadingWorker).to receive(:perform_async)
    subject
  end

  it 'changes torrent_entity status' do
    expect { Sidekiq::Testing.inline! { subject } }
      .to change { torrent_entity.reload.status }.to('downloaded')
  end
end
