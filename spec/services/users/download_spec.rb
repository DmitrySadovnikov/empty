require_relative '../../spec_helper'

describe Users::Create do
  subject { described_class.call(data) }

  let(:data) { attributes_for(:user_auth)[:data] }

  it 'creates user' do
    expect { subject }.to change { User.count }.by(1)
  end

  it 'creates user_auth' do
    expect { subject }.to change { UserAuth.count }.by(1)
  end

  it 'returns correct result' do
    expect(subject).to eq([:ok, User.last])
  end

  context 'with existing user' do
    let!(:user) { create(:user, email: data['info']['email']) }

    it 'does not create user' do
      expect { subject }.not_to change { User.count }
    end

    it 'creates user_auth' do
      expect { subject }.to change { UserAuth.count }.by(1)
    end

    it 'returns correct result' do
      expect(subject).to eq([:ok, user])
    end
  end

  context 'with existing user_auth' do
    let!(:user_auth) { create(:user_auth) }

    it 'does not create user' do
      expect { subject }.not_to change { User.count }
    end

    it 'does not create user_auth' do
      expect { subject }.not_to change { UserAuth.count }
    end

    it 'returns correct result' do
      expect(subject).to eq([:ok, user_auth.user])
    end
  end
end
