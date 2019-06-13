module Web
  module V1
    class TrackersController < ApplicationController
      post '/web/v1/trackers/search' do
        content_type 'application/json'
        TrackersPage.new(params.to_h.symbolize_keys).to_h.to_json
      end
    end
  end
end
