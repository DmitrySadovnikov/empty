module Trackers
  module Rutracker
    class Show < ApplicationService
      param :id

      def call
        return [:invalid, nil] unless post

        image_url = select_image_url
        magnet_link = select_magnet_link
        clean_post

        result = {
          id: id,
          link: "https://rutracker.org/forum/viewtopic.php?t=#{id}",
          image_url: image_url,
          magnet_link: magnet_link,
          text: ReverseMarkdown.convert(post).strip
        }
        [:ok, result]
      end

      private

      def response
        @response ||=
          Curl.get('https://rutracker.org/forum/viewtopic.php', t: id) do |curl|
            curl.headers['Content-Type'] = 'application/html'
            curl.proxy_tunnel = true
            curl.proxy_url = ENV['PROXY_URL']
            curl.proxypwd = ENV['PROXY_PWD']
          end
      end

      def post
        @post ||= begin
          page = Nokogiri::HTML(response.body.force_encoding('windows-1251').encode('utf-8'))
          page.css('.post_wrap').first
        end
      end

      def select_image_url
        image = post.css('.postImg').first
        return unless image

        image.attributes['title'].value
      end

      def select_magnet_link
        post.css('.magnet-link').first.attributes['href'].value.scan(MAGNET_LINK_REGEX)[0]
      end

      def clean_post # rubocop:disable Metrics/AbcSize
        post.css('.post-b').each { |el| el.name = 'b' }
        post.css('span').first.name = 'h1'
        post.css('br').first.remove
        post.css('.postImg').remove
        post.css('.sp-wrap').remove
        post.css('.attach').remove
        post.css('.clear').remove
        post.xpath('//comment()').remove
      end
    end
  end
end
