module Users
  class Create < ApplicationService
    param :data
    option :provider, default: -> { data[:provider] }
    option :email, default: -> { data[:info]['email'] }

    def call
      return [:ok, auth.user] if auth

      UserAuth.create!(user: user, provider: provider, data: data)
      [:ok, user]
    end

    private

    def auth
      @auth ||=
        UserAuth
        .where(provider: provider)
        .where("data ->> 'uid' = ?", data[:uid])
        .order(:created_at).last
    end

    def user
      @user ||= User.find_or_create_by(email: email)
    end
  end
end
