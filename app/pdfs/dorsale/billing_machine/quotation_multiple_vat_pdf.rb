module Dorsale
  module BillingMachine
    class QuotationMultipleVatPdf < ::Dorsale::BillingMachine::InvoiceMultipleVatPdf
      def build
        super
        build_attachments
      end

      def build_attachments
        @main_document.attachments.each do |attachment|
          next unless File.extname(attachment.file.path) == ".pdf"

          file     = attachment.file.path
          nb_pages = ::CombinePDF.load(file).pages.count

          nb_pages.times do |i|
            start_new_page template: file, template_page: (i+1)
          end
        end
      end

      def main_document_type
        Dorsale::BillingMachine::Quotation.model_name.human.humanize
      end

      def build_bank_informations
      end

      def build_expiry
        return if @main_document.expires_at.nil?
        top = bounds.top - 11.5.cm
        height = 0.5.cm
        width  = 7.5.cm

        bounding_box [bounds.left, top], height: height, width: width do
          draw_bounds_debug
          font_size 9 do
            text "<b>#{I18n.t("pdfs.expires_at")}</b> #{I18n.l(@main_document.expires_at)}", inline_format: true
          end
        end
      end

      def build_comments
        return if @main_document.comments.blank?
        top = bounds.top - 12.cm
        height = 1.5.cm
        width  = 10.cm

        font_size 9 do
          text_box @main_document.comments,
            :at       => [bounds.left, top],
            :height   => height,
            :width    => width,
            :overflow => :shrink_to_fit
        end
      end
    end
  end
end
