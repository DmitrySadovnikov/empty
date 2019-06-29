module Web
  module V1
    class TransfersController < ApplicationController
      get '/web/v1/transfers' do
        content_type 'application/json'
        TransfersPage.new(current_user).to_h.to_json
      end

      post '/web/v1/transfers' do
        content_type 'application/json'
        body = JSON.parse(request.body.read).symbolize_keys
        _, resource = Transfers::Create.call(current_user, body)
        TransferPage.new(resource).to_h.to_json
      end
    end
  end
end
