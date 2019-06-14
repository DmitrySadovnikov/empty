require_relative '../../spec_helper'

describe TorrentEntities::PrepareToUpload do
  subject { described_class.call(torrent_entity) }

  let(:user) { create(:user, :with_auth) }
  let(:torrent_entity) do
    create(:torrent_entity, user: user, status: :downloaded, name: 'test.pdf')
  end

  shared_examples 'common cases' do
    it 'changes torrent_entity status' do
      expect { subject }.to change { torrent_entity.status }.to('uploaded')
    end

    it 'changes torrent_entity cloud_file_id' do
      expect { subject }.to change { torrent_entity.cloud_file_id }.to('1')
    end

    it 'changes torrent_entity cloud_file_url' do
      expect { subject }.to change { torrent_entity.cloud_file_url }.to('http://example.com')
    end

    it 'does not call Users::UpdateAuthToken' do
      expect(Users::UpdateAuthToken).not_to receive(:call)
      subject
    end

    it 'creates FileEntity' do
      expect { subject }.to change { CloudEntity.count }
    end
  end

  context 'with file' do
    let(:torrent_entity) do
      create(:torrent_entity, user: user, status: :downloaded, name: 'test.pdf')
    end

    it_behaves_like 'common cases'
  end

  context 'with dir' do
    let(:torrent_entity) do
      create(:torrent_entity, user: user, status: :downloaded, name: 'test')
    end

    it_behaves_like 'common cases'

    it 'creates multiple cloud_entities' do
      expect { subject }.to change { CloudEntity.count }.by(2)
    end
  end

  context 'with auth error' do
    let(:new_token_object) do
      double(
        'token' => SecureRandom.uuid,
        'refresh_token' => SecureRandom.uuid,
        'expires_at' => Time.current.to_i
      )
    end

    before do
      allow(Google::UploadToDrive).to receive(:call)
                                        .and_raise(Google::Apis::AuthorizationError, :error)
      allow_any_instance_of(OAuth2::AccessToken)
        .to receive(:refresh!).and_return(new_token_object)
    end

    it 'calls Users::UpdateAuthToken' do
      expect(Users::UpdateAuthToken).to receive(:call).with(user).twice
      subject
    rescue Google::Apis::AuthorizationError
      nil
    end

    it 'calls Google::UploadToDrive' do
      expect(Google::UploadToDrive).to receive(:call).twice
      subject
    rescue Google::Apis::AuthorizationError
      nil
    end
  end
end
