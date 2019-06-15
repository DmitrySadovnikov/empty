module Web
  module V1
    class CloudEntityPage < Tram::Page
      param :resource
      section :id, value: -> { resource.id }
      section :cloud_file_url, value: -> { resource.cloud_file_url }
      section :status, value: -> { resource.status }
      section :created_at, value: -> { resource.created_at }
    end
  end
end
