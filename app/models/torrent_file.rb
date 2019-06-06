class TorrentFile < ApplicationRecord
  include AASM

  validates :magnet_link, format: { with: /magnet:\?xt=urn:btih:[a-zA-Z0-9]*/ }

  enum status: {
    pending: 1,
    done: 2
  }, _prefix: :status

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :done

    event(:status_done) { transitions from: :pending, to: :done }
  end
end
