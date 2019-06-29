module Providers
  module Rutracker
    class Post < ApplicationService
      param :outer_id

      def call
        return [:no_post, nil] unless post

        magnet_link = select_magnet_link
        return [:no_magnet_link, nil] unless magnet_link

        title = select_title
        image_url = select_image_url
        torrent_size = select_torrent_size
        clean_post
        result = {
          outer_id: outer_id,
          image_url: image_url,
          magnet_link: magnet_link,
          title: title,
          body: text,
          torrent_size: torrent_size
        }
        [:ok, result]
      end

      private

      def response
        @response ||=
          Curl.get('https://rutracker.org/forum/viewtopic.php', t: outer_id) do |curl|
            curl.headers['Content-Type'] = 'application/html'
            curl.headers['Cookie'] = ENV['RUTRACKER_COOKIE']
            curl.proxy_tunnel = true
            curl.proxy_url = ENV['PROXY_URL']
            curl.proxypwd = ENV['PROXY_PWD']
          end
      end

      def response_body
        @response_body ||=
          response.body.force_encoding('windows-1251').encode('utf-8')
      end

      def page
        @page ||= Nokogiri::HTML(response_body)
      end

      def post
        @post ||= page.css('.post_wrap').first
      end

      def text
        @text ||= begin
          result = ReverseMarkdown.convert(post)
          result.gsub('** :', '**:').tr('●', '-').strip
        end
      end

      def select_image_url
        image = post.css('.postImg').first
        return unless image

        image.attributes['title'].value
      end

      def select_magnet_link
        result = post.css('.magnet-link').first
        return unless result

        result.attributes['href'].value.scan(MAGNET_LINK_REGEX)[0]
      end

      def select_torrent_size
        result = page.css('#tor-size-humn').first
        return unless result

        result.attributes['title'].value
      end

      def select_title
        page.css('#topic-title').text
      end

      def clean_post # rubocop:disable Metrics/AbcSize
        post.css('.post-i').each { |el| el.name = 'i' }
        post.css('.post-b').each { |el| el.name = 'b' }
        post.css('hr').remove
        post.css('a').remove
        post.css('script').remove
        post.css('style').remove
        post.css('input').remove
        post.css('.postImg').remove
        post.css('.sp-wrap').remove
        post.css('.attach').remove
        post.css('.clear').remove
        post.css('.signature').remove
        post.css('#tor-fl-wrap')&.remove
        post.xpath('//comment()').remove
      end
    end
  end
end
