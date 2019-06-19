module Trackers
  module Rutracker
    class Search < ApplicationService
      BOOK_FORMATS = %i[PDF EPUB MOBI IBA AZW AZW3].freeze

      param :search

      def call
        result = tracker_post_ids.map { |id| Show.call(id).last }.compact
        [:ok, result]
      end

      private

      def list
        @list ||= begin
          page = Nokogiri::HTML(response.body.force_encoding('windows-1251').encode('utf-8'))
          page.css('.tLink')
        end
      end

      def tracker_post_ids
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
