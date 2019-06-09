require_relative '../../spec_helper'

describe TorrentEntities::Upload do
  subject { described_class.call(torrent_entity) }

  let(:user) { create(:user, :with_auth) }
  let(:torrent_entity) { create(:torrent_entity, user: user, status: :downloaded, name: 'test.pdf') }

  before do
    allow_any_instance_of(Google::Apis::DriveV3::DriveService)
      .to receive(:create_file).and_return(double(id: 1))
    allow_any_instance_of(Google::Apis::DriveV3::DriveService)
      .to receive(:create_permission).and_return(double(id: 1))
    allow_any_instance_of(Google::Apis::DriveV3::DriveService)
      .to receive(:get_file).and_return(double(web_view_link: 'http://example.com'))
  end

  it 'changes torrent_entity status' do
    expect { subject }.to change { torrent_entity.status }.to('uploaded')
  end

  it 'changes torrent_entity google_drive_id' do
    expect { subject }.to change { torrent_entity.google_drive_id }.to('1')
  end

  it 'changes torrent_entity google_drive_view_link' do
    expect { subject }.to change { torrent_entity.google_drive_view_link }.to('http://example.com')
  end
end
