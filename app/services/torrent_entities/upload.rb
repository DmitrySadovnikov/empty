module TorrentEntities
  class Upload < ApplicationService
    APPLICATION_NAME = 'Empty'.freeze

    param :torrent_entity
    option :user, default: -> { torrent_entity.user }
    option :user_auth, default: -> { user.auths.provider_google_oauth2.order(:created_at).last }
    option :drive_service, default: -> { Google::Apis::DriveV3::DriveService.new }
    option :file_path,
           default: -> { [ENV['TRANSMISSION_DOWNLOAD_DIR'], torrent_entity.name].join('/') }

    def call
      torrent_entity.status_uploading!
      _, file_data = upload_to_google_drive
      ActiveRecord::Base.transaction do
        torrent_entity.update!(google_drive_id: file_data[:id],
                               google_drive_view_link: file_data[:web_view_link])
        torrent_entity.status_uploaded!
      end

      [:ok, torrent_entity]
    end

    private

    def upload_to_google_drive
      Retriable.retriable(
        tries: 2,
        on: [Google::Apis::AuthorizationError, Signet::AuthorizationError],
        on_retry: proc { Users::UpdateAuthToken.call(user) }
      ) do
        Google::UploadToDrive.call(
          file_name: torrent_entity.name,
          file_path: file_path,
          credentials: user_auth.reload.data['credentials']
        )
      end
    end
  end
end
