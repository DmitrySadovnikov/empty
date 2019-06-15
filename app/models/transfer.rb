class Transfer < ApplicationRecord
  include AASM

  belongs_to :user
  has_one :torrent_entity
  has_many :cloud_entities

  validates :user, presence: true

  enum status: {
    downloading: 1,
    downloaded: 2,
    prepared: 3,
    uploading: 4,
    uploaded: 5
  }, _prefix: :status

  aasm column: :status, enum: true do
    after_all_transitions :log_state_change

    state :downloading, initial: true
    state :downloaded
    state :prepared
    state :uploading
    state :uploaded

    event(:status_downloaded) { transitions from: :downloading, to: :downloaded }
    event(:status_prepared) { transitions from: :downloaded, to: :prepared }
    event(:status_uploading) { transitions from: :prepared, to: :uploading }
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
