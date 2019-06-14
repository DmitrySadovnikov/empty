module CloudEntities
  class Upload < ApplicationService
    APPLICATION_NAME = 'Empty'.freeze

    param :cloud_entity
    option :transfer, default: -> { cloud_entity.transfer }
    option :user, default: -> { transfer.user }
    option :user_auth, default: -> { user.auths.provider_google_oauth2.order(:created_at).last }
    option :drive_service, default: -> { Google::Apis::DriveV3::DriveService.new }

    def call
      cloud_entity.status_uploading!
      _, file_data = upload_to_google_drive

      ActiveRecord::Base.transaction do
        cloud_entity.update!(cloud_file_id: file_data[:id], cloud_file_url: file_data[:url])
        cloud_entity.status_uploaded!
      end

      transfer.status_uploaded! if transfer.cloud_entities.all?(&:status_uploaded?)
      [:ok, cloud_entity]
    end

    private

    def try_upload_to_google_drive
      Retriable.retriable(
        tries: 2,
        on: [Google::Apis::AuthorizationError, Signet::AuthorizationError],
        on_retry: proc { Users::UpdateAuthToken.call(user) }
      ) { upload_to_google_drive }
    end

    def upload_to_google_drive
      Google::UploadToDrive.call(
        parents: [cloud_entity.parent],
        file_name: File.basename(cloud_entity.file_path),
        file_path: cloud_entity.file_path,
        credentials: user_auth.reload.data['credentials']
      )
    end
  end
end
