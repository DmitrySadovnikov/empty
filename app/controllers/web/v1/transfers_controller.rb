module Web
  module V1
    class TransfersController < ApplicationController
      get '/web/v1/transfers' do
        content_type 'application/json'
        TransfersPage.new(current_user).to_h.to_json
      end

      post '/web/v1/transfers' do
        content_type 'application/json'
        _, resource = Transfers::Create.call(current_user, params)
        TransferPage.new(resource).to_h.to_json
      end
    end
  end
end
