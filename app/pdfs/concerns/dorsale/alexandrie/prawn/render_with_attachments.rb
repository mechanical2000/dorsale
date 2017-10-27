module Dorsale::Alexandrie::Prawn::RenderWithAttachments
  def render_with_attachments
    final_pdf = ::CombinePDF.parse(render)

    attachments.each do |attachment|
      next unless File.extname(attachment.file.path) == ".pdf"

      final_pdf << ::CombinePDF.load(attachment.file.path)
    end

    final_pdf.to_pdf
  end
end
