class Dorsale::ImageUploader < ::Dorsale::ApplicationUploader
  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end
