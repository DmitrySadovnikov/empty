require_relative '../../spec_helper'

describe Transfers::PrepareToUpload do
  subject { described_class.call(transfer) }

  let(:user) { create(:user, :with_auth) }
  let(:transfer) { create(:transfer, user: user, status: :downloaded) }
  let(:torrent_entity_name) { 'test.pdf' }

  before do
    create(:torrent_entity, transfer: transfer, status: :downloaded, name: torrent_entity_name)
  end

  shared_examples 'common cases' do
    it 'changes transfer status' do
      expect { subject }.to change { transfer.status }.to('prepared')
    end

    it 'creates CloudEntity' do
      expect { subject }.to change { CloudEntity.count }
    end

    it 'does not call Users::UpdateAuthToken' do
      expect(Users::UpdateAuthToken).not_to receive(:call)
      subject
    end
  end

  context 'with file' do
    let(:torrent_entity_name) { 'test.pdf' }

    it_behaves_like 'common cases'
  end

  context 'with folder' do
    let(:torrent_entity_name) { 'test folder' }
    let(:created_cloud_entity_folder) { CloudEntity.order(:created_at).first }
    let(:created_cloud_entity_file) { CloudEntity.order(:created_at).last }

    it_behaves_like 'common cases'

    it 'creates multiple CloudEntity' do
      expect { subject }.to change { CloudEntity.count }.by(4)
    end

    it 'creates folder CloudEntity' do
      subject
      expect(created_cloud_entity_folder.children).to include(created_cloud_entity_file)
    end

    it 'creates file CloudEntity' do
      subject
      expect(created_cloud_entity_file.parent).to eq(created_cloud_entity_folder)
    end
  end
end
