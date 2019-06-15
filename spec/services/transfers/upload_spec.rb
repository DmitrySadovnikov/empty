require_relative '../../spec_helper'

describe Transfers::Upload do
  subject { described_class.call(transfer) }

  let(:user) { create(:user, :with_auth) }
  let(:transfer) { create(:transfer, user: user, status: :prepared) }

  it 'changes transfer status' do
    expect { subject }.to change { transfer.reload.status }.to('uploading')
  end
end
