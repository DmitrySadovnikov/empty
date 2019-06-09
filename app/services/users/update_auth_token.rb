module Users
  class UpdateAuthToken < ApplicationService
    param :user
    option :user_auth, default: -> { user.auths.provider_google_oauth2.order(:created_at).last }
    option :token, default: -> { user_auth.data['credentials']['token'] }
    option :refresh_token, default: -> { user_auth.data['credentials']['refresh_token'] }

    def call
      new_token_object = token_object.refresh!
      new_credentials = {
        'token' => new_token_object.token,
        'refresh_token' => new_token_object.refresh_token,
        'expires_at' => new_token_object.expires_at
      }
      user_auth.data['credentials'].merge!(new_credentials)
      user_auth.save!
    end

    private

    def strategy
      OmniAuth::Strategies::GoogleOauth2.new(nil, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET'])
    end

    def token_object
      OAuth2::AccessToken.new(strategy.client, token, refresh_token: refresh_token)
    end
  end
end
