class TorrentFile < ApplicationRecord
  include AASM

  belongs_to :user

  validates :user, presence: true
  validates :magnet_link, format: { with: /magnet:\?xt=urn:btih:[a-zA-Z0-9]*/ }

  enum status: {
    pending: 1,
    downloaded: 2,
    uploaded: 3
  }, _prefix: :status

  aasm column: :status, enum: true do
    after_all_transitions :log_state_change

    state :pending, initial: true
    state :downloaded
    state :uploaded

    event(:status_downloaded) { transitions from: :pending, to: :downloaded }
    event(:status_uploaded) { transitions from: :downloaded, to: :uploaded }
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
