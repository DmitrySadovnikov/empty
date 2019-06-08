class UserAuth < ApplicationRecord
  belongs_to :user

  enum provider: {
    google_oauth2: 1
  }, _prefix: :provider
end
