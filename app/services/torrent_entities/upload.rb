module TorrentEntities
  class Upload < ApplicationService
    APPLICATION_NAME = 'Empty'.freeze

    param :torrent_entity
    option :drive_service, default: -> { Google::Apis::DriveV3::DriveService.new }
    option :upload_source,
           default: -> { [ENV['TRANSMISSION_DOWNLOAD_DIR'], torrent_entity.name].join('/') }

    def call
      torrent_entity.status_uploading!
      drive_service.client_options.application_name = APPLICATION_NAME
      drive_service.authorization = authorization
      uploaded_file = upload_file

      ActiveRecord::Base.transaction do
        torrent_entity.update!(google_drive_id: uploaded_file.id)
        torrent_entity.status_uploaded!
      end

      [:ok, torrent_entity]
    end

    private

    def upload_file
      file_metadata = { name: torrent_entity.name }
      drive_service.create_file(file_metadata, upload_source: upload_source)
    end

    def authorization
      @authorization ||= Google::Auth::UserRefreshCredentials.new(
        client_id: ENV['GOOGLE_KEY'],
        client_secret: ENV['GOOGLE_SECRET'],
        scope: Google::Apis::DriveV3::AUTH_DRIVE_FILE,
        access_token: user_auth.data['credentials']['token'],
        refresh_token: user_auth.data['credentials']['refresh_token'],
        expiration_time_millis: user_auth.data['credentials']['expires_at']
      )
    end

    def user_auth
      @user_auth ||=
        torrent_entity.user.auths.provider_google_oauth2.order(:created_at).last
    end
  end
end
