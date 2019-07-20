class TorrentEntity < ApplicationRecord
  include AASM

  belongs_to :transfer
  belongs_to :torrent_post, optional: true
  belongs_to :torrent_file, optional: true

  validates :transfer, presence: true
  validates :torrent_post, presence: true, if: :trigger_torrent_post?
  validates :torrent_file, presence: true, if: :trigger_torrent_file?
  validates :magnet_link, presence: true, if: :trigger_magnet_link?
  validates :magnet_link, format: { with: MAGNET_LINK_REGEX }, if: :magnet_link

  enum status: {
    downloading: 1,
    downloaded: 2
  }, _prefix: :status

  enum trigger: {
    torrent_post: 1,
    torrent_file: 2,
    magnet_link: 3
  }, _prefix: :trigger

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
