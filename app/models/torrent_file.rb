class TorrentFile < ApplicationRecord
  mount_uploader :value, TorrentFileUploader
end
