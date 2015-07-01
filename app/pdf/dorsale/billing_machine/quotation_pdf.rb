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
        "Devis"
      end

      def build_bank_infos
      end

      def build_synthesis
        font_size 10
          @table_matrix.push ['Net HT', '', '', euros(@main_document.total_duty)]
          vat_rate = french_number(@main_document.vat_rate)
          @table_matrix.push ["TVA #{vat_rate} %", '', '', euros(@main_document.vat_amount)]
          @table_matrix.push ['Total TTC', '', '', euros(@main_document.total_all_taxes)]
          write_table_from_matrix(@table_matrix)
      end

      def build_expiry
        return if @main_document.expires_at.nil?
        move_down 15
        text "Date d'expiration : " + I18n.l(@main_document.expires_at)
      end

      def build_comments
        bounding_box [50, 140], :width => 445, :height => 50 do
         draw_bounds_debug
         font_size 9
         text @main_document.comments
        end
      end
    end
  end
end
