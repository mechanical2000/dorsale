class Dorsale::ImageUploader < ::Dorsale::ApplicationUploader
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
