class CloudEntity < ApplicationRecord
  include AASM

  belongs_to :transfer
  belongs_to :parent, class_name: 'CloudEntity', optional: true, foreign_key: :parent_id
  has_many :children, class_name: 'CloudEntity', foreign_key: :parent_id

  validates :transfer, presence: true

  scope :kind_folder, -> { where(mime_type: Google::MIME_TYPE_FOLDER) }
  scope :kind_file, -> { where.not(id: CloudEntity.kind_folder.select(:id)) }

  enum status: {
    created: 1,
    uploading: 2,
    uploaded: 3
  }, _prefix: :status

  aasm column: :status, enum: true do
    after_all_transitions :log_state_change

    state :created, initial: true
    state :uploading
    state :uploaded

    event(:status_uploading) { transitions from: :created, to: :uploading }
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
