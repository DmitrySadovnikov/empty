class TorrentFile < ApplicationRecord
  include AASM

  validates :magnet_link, format: { with: /magnet:\?xt=urn:btih:[a-zA-Z0-9]*/ }

  enum status: {
    pending: 1,
    done: 2,
    deleted: 3
  }, _prefix: :status

  aasm column: :status, enum: true do
    after_all_transitions :log_state_change

    state :pending, initial: true
    state :done

    event(:status_done) { transitions from: :pending, to: :done }
  end

  store_accessor :data,
                 :status_history

  def log_state_change
    self.status_history = (status_history || []) << {
      from_state: aasm.from_state,
      to_state: aasm.to_state,
      event: aasm.current_event,
      changed_at: Time.current
    }
  end
end
