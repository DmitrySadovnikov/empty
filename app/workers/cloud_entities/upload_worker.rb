module CloudEntities
  class UploadWorker
    include Sidekiq::Worker

    sidekiq_options lock: :until_executed, on_conflict: :log, queue: :default

    def perform(cloud_entity_id)
      cloud_entity = CloudEntity.find_by(id: cloud_entity_id)
      return unless cloud_entity

      Upload.call(cloud_entity)
    end
  end
end
