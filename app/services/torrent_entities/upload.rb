module TorrentEntities
  class Upload < ApplicationService
    APPLICATION_NAME = 'Empty'.freeze

    param :torrent_entity
    option :drive_service, default: -> { Google::Apis::DriveV3::DriveService.new }
    option :file_path,
           default: -> { [ENV['TRANSMISSION_DOWNLOAD_DIR'], torrent_entity.name].join('/') }

    def call
      torrent_entity.status_uploading!
      _, file_data = GoogleDrive::Upload.call(
        file_name: torrent_entity.name,
        file_path: file_path,
        credentials: user_auth.data['credentials']
      )

      ActiveRecord::Base.transaction do
        torrent_entity.update!(google_drive_id: file_data[:id],
                               google_drive_view_link: file_data[:web_view_link])
        torrent_entity.status_uploaded!
      end

      [:ok, torrent_entity]
    end

    private

    def user_auth
      @user_auth ||=
        torrent_entity.user.auths.provider_google_oauth2.order(:created_at).last
    end
  end
end
