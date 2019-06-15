module Transfers
  class PrepareToUpload < ApplicationService
    param :transfer
    option :torrent_entity, default: -> { transfer.torrent_entity }
    option :download_path,
           default: -> { [ENV['TRANSMISSION_DOWNLOAD_DIR'], torrent_entity.name].join('/') }

    def call
      ActiveRecord::Base.transaction do
        transfer.status_prepared!
        create_cloud_entities(download_path)
        UploadWorker.perform_async(transfer.id)
      end

      [:ok, transfer]
    end

    private

    def create_cloud_entities(path, parent: nil)
      if File.file?(path)
        create_cloud_entity(path, parent: parent)
      elsif File.directory?(path)
        folder = create_cloud_entity(path, mime_type: Google::MIME_TYPE_FOLDER, parent: parent)
        Dir["#{path}/*"].each { |sub_path| create_cloud_entities(sub_path, parent: folder) }
      else
        raise "invalid path #{path}"
      end
    end

    def create_cloud_entity(path, mime_type: nil, parent: nil)
      CloudEntity.create!(
        file_path: path,
        mime_type: mime_type,
        parent: parent,
        transfer: transfer,
        status: :created
      )
    end
  end
end
