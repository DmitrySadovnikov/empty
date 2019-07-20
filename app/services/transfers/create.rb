module Transfers
  class Create < ApplicationService
    param :user
    param :params

    def call
      transfer = Transfer.new(user: user)
      case trigger
      when :torrent_post
        TorrentEntities::DownloadTorrentPost.call(transfer, torrent_post)
      when :torrent_file
        TorrentEntities::DownloadTorrentFile.call(transfer, torrent_file)
      when :magnet_link
        TorrentEntities::DownloadMagnetLink.call(transfer, params[:magnet_link])
      end
      [:ok, transfer]
    end

    private

    def trigger
      return :torrent_post if params[:torrent_post_id]
      return :torrent_file if params[:torrent_file_id]
      return :magnet_link if params[:magnet_link]

      raise "invalid params #{params}"
    end

    def torrent_post
      TorrentPost.find(params[:torrent_post_id])
    end

    def torrent_file
      TorrentFile.find(params[:torrent_file_id])
    end
  end
end
