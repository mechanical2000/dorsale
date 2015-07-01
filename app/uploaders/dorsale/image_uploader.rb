module Dorsale
  class ImageUploader < ::Dorsale::FileUploader
    def extension_white_list
      %w(jpg jpeg gif png)
    end
  end
end
