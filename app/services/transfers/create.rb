module Transfers
  class Create < ApplicationService
    param :user
    param :params

    def call
      transfer = Transfer.create!(user: user)
      _, torrent_entity = TorrentEntities::Download.call(transfer, params[:magnet_link])
      torrent_entity.update!(transfer: transfer)
      [:ok, transfer]
    end
  end
end
