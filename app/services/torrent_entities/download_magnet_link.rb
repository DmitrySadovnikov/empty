module TorrentEntities
  class DownloadMagnetLink < ApplicationService
    param :transfer
    param :magnet_link

    def call
      return [:invalid, torrent_entity] unless torrent_entity.valid?

      parsed_response = JSON.parse(response.body)
      return [:no_torrent, torrent_entity] if parsed_response['result'] != 'success'

      torrent_entity.transmission_id = parsed_response['arguments']['id']
      ActiveRecord::Base.transaction do
        transfer.save!
        torrent_entity.save!
      end

      [:ok, torrent_entity]
    end

    private

    def request_body
      {
        method: 'torrent-add',
        arguments: {
          filename: magnet_link
        }
      }
    end

    def response
      @response ||= begin
        response = make_request
        if response.response_code == 409
          _, *response_headers = response.header_str.split(/[\r\n]+/).map(&:strip)
          response_headers = Hash[response_headers.flat_map { |s| s.scan(/^(\S+): (.+)/) }]
          Sinatra::Cache::RedisStore.new.write(
            'x-transmission-session-id',
            response_headers['X-Transmission-Session-Id']
          )
          response = make_request
        end
        response
      end
    end

    def make_request
      Curl.post(ENV['TRANSMISSION_URL'], request_body.to_json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
        curl.headers['Accept'] = 'application/json'
        curl.headers['X-Transmission-Session-Id'] =
          Sinatra::Cache::RedisStore.new.read('x-transmission-session-id')
      end
    end

    def torrent_entity
      @torrent_entity ||= TorrentEntity.new(
        transfer: transfer,
        magnet_link: magnet_link,
        trigger: :magnet_link,
        status: :downloading
      )
    end
  end
end
