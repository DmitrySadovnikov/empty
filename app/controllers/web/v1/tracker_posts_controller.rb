module Web
  module V1
    class TrackerPostsController < Sinatra::Base
      get '/web/v1/tracker_posts/search' do
        content_type 'application/json'
        TrackerPostsPage.new(params.deep_symbolize_keys).to_h.to_json
        # File.read('spec/fixtures/files/rutracker/search.json')
      end
    end
  end
end
