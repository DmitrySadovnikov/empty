module GoogleDrive
  class Upload < ApplicationService
    option :file_name
    option :file_path
    option :credentials
    option :drive_service, default: -> { Google::Apis::DriveV3::DriveService.new }
    option :application_name, default: -> { 'Empty' }

    def call
      drive_service.client_options.application_name = application_name
      drive_service.authorization = authorization
      file = upload_file
      link = web_view_link(file.id)
      result = {
        id: file.id,
        web_view_link: link
      }
      [:ok, result]
    end

    private

    def web_view_link(file_id)
      permission = Google::Apis::DriveV3::Permission.new(type: :anyone, role: :reader)
      drive_service.create_permission(file_id, permission)
      drive_service.get_file(file_id, fields: 'web_view_link').web_view_link
    end

    def upload_file
      file_metadata = { name: file_name }
      drive_service.create_file(file_metadata, upload_source: file_path)
    end

    def authorization
      @authorization ||= Google::Auth::UserRefreshCredentials.new(
        client_id: ENV['GOOGLE_KEY'],
        client_secret: ENV['GOOGLE_SECRET'],
        scope: Google::Apis::DriveV3::AUTH_DRIVE_FILE,
        access_token: credentials['token'],
        refresh_token: credentials['refresh_token'],
        expiration_time_millis: credentials['expires_at']
      )
    end
  end
end
