require_relative '../../spec_helper'

describe TorrentFiles::CheckPendingWorker do
  subject { described_class.new.perform }

  let!(:torrent_file) { create(:torrent_file, status: :pending) }

  it_behaves_like 'should present at the cron schedule'

  it 'calls TorrentFiles::Check' do
    expect(TorrentFiles::Check).to receive(:call)
    subject
  end
end
