class TorrentEntity < ApplicationRecord
  include AASM

  belongs_to :transfer
  belongs_to :torrent_post

  validates :transfer, :torrent_post, presence: true

  enum status: {
    downloading: 1,
    downloaded: 2
  }, _prefix: :status

  aasm column: :status, enum: true do
    after_all_transitions :log_state_change

    state :downloading, initial: true
    state :downloaded

    event(:status_downloaded) { transitions from: :downloading, to: :downloaded }
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
