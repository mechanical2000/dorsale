module Dorsale
  module Alexandrie
    module Prawn
      def render_with_attachments
        final_pdf = ::CombinePDF.parse(self.render)

        attachments.each do |attachment|
          next unless File.extname(attachment.file.path) == ".pdf"

          final_pdf << ::CombinePDF.load(attachment.file.path)
        end

        final_pdf.to_pdf
      end
    end
  end
end
