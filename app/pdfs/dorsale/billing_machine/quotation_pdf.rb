module Dorsale
  module BillingMachine
    class QuotationPdf < ::Dorsale::BillingMachine::InvoicePdf
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

      def build_bank_infos
      end

      def build_synthesis
        font_size 10
          if (@main_document.commercial_discount && @main_document.commercial_discount != 0.0)
            @table_matrix.push ["#{I18n.t("pdfs.commercial_discount")}", '', '', euros(@main_document.commercial_discount)]
          end
          @table_matrix.push ["#{I18n.t("pdfs.total_duty")}", '', '', euros(@main_document.total_duty)]
          vat_rate = french_number(@main_document.vat_rate)
          @table_matrix.push ["#{I18n.t("pdfs.vat")}#{vat_rate} %", '', '', euros(@main_document.vat_amount)]
          @table_matrix.push ["#{I18n.t("pdfs.total_all_taxes")}", '', '', euros(@main_document.total_all_taxes)]
          write_table_from_matrix(@table_matrix)
      end

      def build_expiry
        return if @main_document.expires_at.nil?
        move_down 15
        text "Date d'expiration : " + I18n.l(@main_document.expires_at)
      end

      def build_comments
        top = bounds.top - 22.4.cm
        height = 1.cm
        width  = 7.5.cm

        bounding_box [bounds.left, top], height: height, width: width do
          draw_bounds_debug
          text @main_document.comments if @main_document.comments.present?
        end

      end
    end
  end
end
