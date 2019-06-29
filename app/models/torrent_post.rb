class TorrentPost < ApplicationRecord
  include AASM

  validates :provider, :outer_id, :magnet_link, :title, :body, presence: true
  validates :magnet_link, format: { with: MAGNET_LINK_REGEX }

  enum provider: {
    rutracker: 1
  }, _prefix: :provider
end
