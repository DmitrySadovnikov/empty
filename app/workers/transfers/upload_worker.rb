module Transfers
  class UploadWorker
    include Sidekiq::Worker

    sidekiq_options lock: :until_executed, on_conflict: :log, queue: :default

    def perform(transfers_id)
      transfers = Transfer.find_by(id: transfers_id)
      return unless transfers

      Upload.call(transfers)
    end
  end
end
