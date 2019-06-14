module Web
  module V1
    class TorrentEntityPage < Tram::Page
      param :resource
      section :id, value: -> { resource.id }
      section :name, value: -> { resource.name }
      section :status, value: -> { resource.status }
      section :created_at, value: -> { resource.created_at }
    end
  end
end
