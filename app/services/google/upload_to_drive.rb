module Google
  MIME_TYPE_FOLDER = 'application/vnd.google-apps.folder'.freeze

  class UploadToDrive < ApplicationService
    option :file_name
    option :file_path
    option :credentials
    option :parents, optional: true
    option :mime_type, optional: true
    option :drive_service, default: -> { Apis::DriveV3::DriveService.new }
    option :application_name, default: -> { 'Empty' }

    def call
      drive_service.client_options.application_name = application_name
      drive_service.authorization = authorization
      file = upload_file
      result = { id: file.id, url: cloud_file_url(file.id), mime_type: file.mime_type }
      [:ok, result]
    end

    private

    def cloud_file_url(file_id)
      permission = Apis::DriveV3::Permission.new(type: :anyone, role: :reader)
      drive_service.create_permission(file_id, permission)
      drive_service.get_file(file_id, fields: 'web_view_link').web_view_link
    end

    def upload_file
      file_metadata = { name: file_name,
                        mime_type: mime_type,
                        parents: parents }
      upload_source = file_path unless MIME_TYPE_FOLDER == mime_type
      drive_service.create_file(file_metadata, upload_source: upload_source)
    end

    def authorization
      @authorization ||= Auth::UserRefreshCredentials.new(
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_SECRET'],
        scope: Apis::DriveV3::AUTH_DRIVE_FILE,
        access_token: credentials['token'],
        refresh_token: credentials['refresh_token'],
        expiration_time_millis: credentials['expires_at']
      )
    end
  end
end
