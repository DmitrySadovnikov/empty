module Transfers
  class Upload < ApplicationService
    param :transfer
    option :cloud_entities_folders,
           default: -> { transfer.cloud_entities.kind_folder.order(:created_at) }
    option :cloud_entities_files,
           default: -> { transfer.cloud_entities.kind_file.order(:created_at) }

    def call
      transfer.status_uploading!
      upload_cloud_folders
      upload_cloud_files_async
      [:ok, transfer]
    end

    private

    def upload_cloud_folders
      cloud_entities_folders.each { |cloud_entity| CloudEntities::Upload.call(cloud_entity) }
    end

    def upload_cloud_files_async
      cloud_entities_files.each do |cloud_entity|
        CloudEntities::UploadWorker.perform_async(cloud_entity.id)
      end
    end
  end
end
