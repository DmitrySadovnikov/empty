class TorrentFile < ApplicationRecord
  include AASM

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
