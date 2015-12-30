require "mini_magick"

module Dorsale
  class AvatarUploader < ImageUploader
    include CarrierWave::MiniMagick

    process resize_to_fill: [200, 200]
  end
end
