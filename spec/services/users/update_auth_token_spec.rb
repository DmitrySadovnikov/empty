require_relative '../../spec_helper'

describe Users::UpdateAuthToken do
  subject { described_class.call(user) }

  let(:user) { create(:user, :with_auth) }
  let(:new_token_object) do
    double(
      'token' => SecureRandom.uuid,
      'refresh_token' => SecureRandom.uuid,
      'expires_at' => Time.current.to_i
    )
  end

  before do
    allow_any_instance_of(OAuth2::AccessToken)
      .to receive(:refresh!).and_return(new_token_object)
  end

  it 'changes token' do
    expect { subject }
      .to change { user.auths.last.data['credentials']['token'] }
      .to(new_token_object.token)
  end
end
