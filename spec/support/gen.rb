module Gen
  class << self
    def random_magnet_link
      "magnet:?xt=urn:btih:#{SecureRandom.hex(20)}"
    end
  end
end
