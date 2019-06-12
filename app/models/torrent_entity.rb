class TorrentEntity < ApplicationRecord
  include AASM

  belongs_to :user

  validates :user, presence: true
  validates :magnet_link, format: { with: MAGNET_LINK_REGEX }

  enum status: {
    downloading: 1,
    downloaded: 2,
    uploading: 3,
    uploaded: 4
  }, _prefix: :status

  aasm column: :status, enum: true do
    after_all_transitions :log_state_change

    state :downloading, initial: true
    state :downloaded
    state :uploading
    state :uploaded

    event(:status_downloaded) { transitions from: :downloading, to: :downloaded }
    event(:status_uploading) { transitions from: :downloaded, to: :uploading }
    event(:status_uploaded) { transitions from: :uploading, to: :uploaded }
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
