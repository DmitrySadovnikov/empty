module Transfers
  class PrepareToUpload < ApplicationService
    param :transfer
    option :torrent_entity, default: -> { transfer.torrent_entity }
    option :download_path,
           default: -> { [ENV['TRANSMISSION_DOWNLOAD_DIR'], torrent_entity.name].join('/') }

    def call
      build_cloud_entities(download_path)

      ActiveRecord::Base.transaction do
        transfer.status_prepared!
        cloud_entities.each(&:save!)
      end
      UploadWorker.perform_async(transfer.id)

      [:ok, transfer]
    end

    private

    def build_cloud_entities(path, parent: nil)
      if File.file?(path)
        build_cloud_entity(path, parent: parent)
      elsif File.directory?(path)
        folder = build_cloud_entity(path, mime_type: Google::MIME_TYPE_FOLDER, parent: parent)
        Dir["#{path}/*"].each { |sub_path| build_cloud_entities(sub_path, parent: folder) }
      else
        raise "invalid path #{path}"
      end
    end

    def build_cloud_entity(path, mime_type: nil, parent: nil)
      result = CloudEntity.new(
        file_path: path,
        mime_type: mime_type,
        parent: parent,
        transfer: transfer,
        status: :created
      )

      cloud_entities << result
      result
    end

    def cloud_entities
      @cloud_entities ||= []
    end
  end
end
