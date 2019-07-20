module Web
  module V1
    class TorrentPostPage < Tram::Page
      param :resource
      section :id, value: -> { resource.id }
      section :provider, value: -> { resource.provider }
      section :outer_id, value: -> { resource.outer_id }
      section :image_url, value: -> { resource.image_url }
      section :magnet_link, value: -> { resource.magnet_link }
      section :title, value: -> { resource.title }
      section :body, value: -> { resource.body }
      section :torrent_size
      section :link

      def link
        case provider.to_sym
        when :rutracker then "https://rutracker.org/forum/viewtopic.php?t=#{outer_id}"
        else raise "invalid provider #{provider}"
        end
      end

      def torrent_size
        size = bytes_to_megabytes(resource.torrent_size).round(2)
        "#{size} MB"
      end

      private

      def bytes_to_megabytes(bytes)
        bytes.to_i / (1024.0 * 1024.0)
      end
    end
  end
end
