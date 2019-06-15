module Transfers
  class PrepareToUploadWorker
    include Sidekiq::Worker

    sidekiq_options lock: :until_executed, on_conflict: :log, queue: :default

    def perform(transfer_id)
      transfer = Transfer.find_by(id: transfer_id)
      return unless transfer

      PrepareToUpload.call(transfer)
    end
  end
end
