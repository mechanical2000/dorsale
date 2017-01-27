class Dorsale::PdfUploader < ::Dorsale::ApplicationUploader
  def extension_white_list
    %w(pdf)
  end
end
