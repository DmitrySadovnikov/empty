class TorrentFile < ApplicationRecord
  enum status: {
    pending: 1,
    done: 2
  }, _prefix: :status
end
