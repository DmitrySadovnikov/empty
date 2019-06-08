require_relative '../../spec_helper'

describe TorrentFiles::Upload do
  subject { described_class.call(torrent_file) }

  let(:user) { create(:user, :with_auth) }
  let(:torrent_file) { create(:torrent_file, user: user, status: :downloaded, name: 'test.pdf') }

  before do
    allow_any_instance_of(Google::Apis::DriveV3::DriveService)
      .to receive(:create_file).and_return(double(id: 1))
  end

  it 'changes torrent_file status' do
    expect { subject }.to change { torrent_file.status }.to('uploaded')
  end

  it 'changes torrent_file google_drive_id' do
    expect { subject }.to change { torrent_file.google_drive_id }.to('1')
  end
end
