class Dorsale::PdfUploader < ::Dorsale::ApplicationUploader
  def extension_allowlist
    %w(pdf)
  end
end
