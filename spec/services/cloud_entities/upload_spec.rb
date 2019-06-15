require_relative '../../spec_helper'

describe CloudEntities::Upload do
  subject { described_class.call(cloud_entity) }

  let(:user) { create(:user, :with_auth) }
  let(:transfer) { create(:transfer, user: user, status: :uploading) }
  let(:cloud_entity) { create(:cloud_entity, :kind_file, transfer: transfer) }

  before do
    allow_any_instance_of(Google::Apis::DriveV3::DriveService)
      .to receive(:create_file).and_return(double(id: 1, mime_type: SecureRandom.uuid))
    allow_any_instance_of(Google::Apis::DriveV3::DriveService)
      .to receive(:create_permission).and_return(double(id: 1))
    allow_any_instance_of(Google::Apis::DriveV3::DriveService)
      .to receive(:get_file).and_return(double(web_view_link: 'http://example.com'))
  end

  it 'changes cloud_entity status' do
    expect { subject }.to change { cloud_entity.status }.to('uploaded')
  end

  it 'changes transfer status' do
    expect { subject }.to change { transfer.status }.to('uploaded')
  end

  it 'creates multiple cloud_entities' do
    expect { subject }.to change { CloudEntity.count }.by(2)
  end

  it 'changes cloud_entity cloud_file_id' do
    expect { subject }.to change { cloud_entity.cloud_file_id }.to('1')
  end

  it 'changes cloud_entity cloud_file_url' do
    expect { subject }.to change { cloud_entity.cloud_file_url }.to('http://example.com')
  end

  it 'does not call Users::UpdateAuthToken' do
    expect(Users::UpdateAuthToken).not_to receive(:call)
    subject
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
