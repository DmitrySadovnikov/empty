module Transfers
  class Create < ApplicationService
    param :user
    param :params
    option :torrent_post, default: -> { TorrentPost.find(params[:torrent_post_id]) }

    def call
      transfer = Transfer.new(user: user)
      TorrentEntities::Download.call(transfer, torrent_post)
      [:ok, transfer]
    end
  end
end
