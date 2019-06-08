class User < ApplicationRecord
  has_many :auths, class_name: 'UserAuth'
  has_many :torrent_files

  validates :email, presence: true, uniqueness: true
end
