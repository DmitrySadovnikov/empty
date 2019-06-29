module Providers
  module Rutracker
    class Search < ApplicationService
      BOOK_FORMATS = %i[PDF EPUB MOBI IBA AZW AZW3].freeze

      param :search

      def call
        result = outer_ids.map do |id|
          post = TorrentPost.provider_rutracker.find_by(outer_id: id)
          next post if post

          status, data = Post.call(id)
          next if status != :ok

          TorrentPost.create!(
            provider: :rutracker,
            outer_id: id,
            magnet_link: data[:magnet_link],
            image_url: data[:image_url],
            title: data[:title],
            body: data[:body],
            torrent_size: data[:torrent_size]
          )
        end.compact

        [:ok, result]
      end

      private

      def list
        @list ||= begin
          page = Nokogiri::HTML(response.body.force_encoding('windows-1251').encode('utf-8'))
          page.css('.tLink')
        end
      end

      def outer_ids
        list.map { |item| item.attributes['href'].value.scan(/t=(.\d*)/)[0][0] }
      end

      def response
        @response ||=
          Curl.post('https://rutracker.org/forum/tracker.php', request_body.to_param) do |curl|
            curl.headers['Content-Type'] = 'application/x-www-form-urlencoded'
            curl.headers['Cookie'] = ENV['RUTRACKER_COOKIE']
            curl.follow_location = true
            curl.proxy_tunnel = true
            curl.proxy_url = ENV['PROXY_URL']
            curl.proxypwd = ENV['PROXY_PWD']
          end
      end

      def request_body
        {
          'f[]': -1,
          o: 10,
          s: 2,
          pn: nil,
          nm: "#{search} #{BOOK_FORMATS.join('|')}"
        }
      end
    end
  end
end
