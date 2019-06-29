require './spec/spec_helper'

describe Web::V1::TorrentPostsController do
  describe 'GET /web/v1/torrent_posts/search' do
    subject { get '/web/v1/torrent_posts/search', params }

    let(:params) do
      {
        search: Faker::Lorem.word
      }
    end

    before do
      stub_request(:post, 'https://rutracker.org/forum/tracker.php')
        .to_return(status: 200,
                   body: File.open('spec/fixtures/files/rutracker/search.html'),
                   headers: {})
      stub_request(:get, /viewtopic.php/)
        .to_return(status: 200,
                   body: File.open('spec/fixtures/files/rutracker/show.html'),
                   headers: {})
    end

    it 'returns 200' do
      subject
      expect(last_response.status).to eq(200)
    end

    it 'creates TorrentPost' do
      expect { subject }.to change { TorrentPost.count }.by(4)
    end

    it 'returns correct json' do
      subject
      expectation = {
        id: TorrentPost.order(:created_at).first.id,
        outer_id: '5460301',
        provider: 'rutracker',
        image_url: 'http://i91.fastpic.ru/big/2017/0930/c2/8b81a8b35b60ef8549e01ff3c95689c2.jpg',
        link: 'https://rutracker.org/forum/viewtopic.php?t=5460301',
        magnet_link: 'magnet:?xt=urn:btih:14EA8DEECC33E2750F9C9B0EAB70F409F4C362E4',
        body: File.read('spec/fixtures/files/rutracker/text.md'),
        title: 'Banks A., Porcello E. - Learning React [2017, PDF, ENG]',
        torrent_size: '0.0 MB'
      }.as_json
      expect(JSON.parse(last_response.body)['collection'][0]).to eq(expectation)
    end
  end
end
