module Users
  class Create < ApplicationService
    param :data
    option :provider, default: -> { data[:provider] }
    option :email, default: -> { data[:info]['email'] }

    def call
      result =
        if auth
          auth.update!(data: data)
          auth.user
        else
          UserAuth.create!(user: user, provider: provider, data: data)
          user
        end

      [:ok, result]
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
