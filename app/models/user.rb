class User < ApplicationRecord
  has_many :auths, class_name: 'UserAuth'
  has_many :transfers
  has_many :torrent_entities, through: :transfers
  has_many :cloud_entities, through: :transfers

  validates :email, presence: true, uniqueness: true
end
