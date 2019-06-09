require_relative '../../spec_helper'

describe TorrentEntities::CheckDownloading do
  subject { described_class.call(torrent_entity) }

  let!(:torrent_entity) { create(:torrent_entity, status: :downloading) }

  before do
    stub_transmission_rpc_request(name: 'name')
  end

  it 'changes torrent_entity status' do
    expect { subject }.to change { torrent_entity.reload.status }.to('downloaded')
  end

  it 'changes torrent_entity name' do
    expect { subject }.to change { torrent_entity.reload.name }.to('name')
  end

  it 'calls TorrentEntities::UploadWorker' do
    subject
    expect(TorrentEntities::UploadWorker).to have_enqueued_sidekiq_job(torrent_entity.id)
  end
end
