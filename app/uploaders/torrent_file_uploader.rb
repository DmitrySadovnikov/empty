class TorrentFileUploader < CarrierWave::Uploader::Base
  def extension_whitelist
    %w[torrent]
  end

  def filename
    "torrent.#{file.extension}" if original_filename.present?
  end

  def store_dir
    [
      ENV['SINATRA_ROOT_PATH'],
      'public',
      'uploads',
      model.class.to_s.underscore,
      model.id
    ].join('/')
  end
end
