require './spec/spec_helper'

describe Web::V1::TorrentFilesController do
  describe 'POST /web/v1/torrent_files' do
    subject { post '/web/v1/torrent_files', params }

    let(:params) do
      {
        torrent_file: Rack::Test::UploadedFile.new('spec/fixtures/files/torrent.torrent')
      }
    end

    let(:created_torrent_file) { TorrentFile.last }

    it 'returns 200' do
      subject
      expect(last_response.status).to eq(200)
    end

    it 'creates TorrentFile' do
      expect { subject }.to change { TorrentFile.count }.by(1)
    end

    it 'returns correct json' do
      subject
      expect(JSON.parse(last_response.body)).to eq(
        'id' => created_torrent_file.id,
        'url' => created_torrent_file.value_url
      )
    end
  end
end
