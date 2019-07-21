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
        code, resource = Transfers::Create.call(current_user, body)

        case code
        when :ok
          status 200
          TransferPage.new(resource).to_h.to_json
        when :invalid
          status 400
          { errors: resource }.to_json
        end
      end
    end
  end
end
