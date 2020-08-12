class Dorsale::PdfUploader < ::Dorsale::ApplicationUploader
  def extension_whitelist
    %w(pdf)
  end
end
