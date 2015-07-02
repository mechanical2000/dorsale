module Dorsale
  module BillingMachine
    class InvoicePdf < Prawn::Document
      include ActionView::Helpers::NumberHelper
      attr_reader :main_document

      GREY       = "808080"
      LIGHT_GREY = "C0C0C0"
      WHITE      = "FFFFFF"
      DEBUG      = false
      FRENCH_MONTH_NAMES = [nil, 'janvier', 'février', 'mars', 'avril', 'mai',
        'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre']

      def main_document_type
        "Facture"
      end

      def initialize(main_document)
        super(:page_size => 'A4')
        @main_document = main_document
        @id_card = @main_document.id_card
      end

      def build
        if @main_document.id_card.logo.present?
          image @main_document.id_card.logo.path , at: [45, 765], :width => 150
        end

        build_legal_infos
        build_header
        build_contact_infos
        build_customer_infos
        build_label
        build_table
        build_comments
        build_footer
      end

      def build_legal_infos
        bounding_box [235, 735], :width => 235, :height => 110 do
          draw_bounds_debug
          font_size 8
          text @id_card.entity_name, align: :right, style: :bold
          write_legal_line 'SIRET ' + @id_card.siret.to_s + ' APE ' + @id_card.ape_naf.to_s
          write_legal_line @id_card.legal_form.to_s + ' au capital de ' + number_with_delimiter(@id_card.capital, :delimiter => '.').to_s + ' euros'
          write_legal_line @id_card.registration_city.to_s + ' ' + @id_card.registration_number.to_s
          move_down 5
          write_legal_line 'N° TVA ' + @id_card.intracommunity_vat.to_s
          move_down 15
          write_legal_line @id_card.address1.to_s
          write_legal_line @id_card.zip.to_s + " " + @id_card.city.to_s
        end
      end

      def build_header
        bounding_box [300, 585], :width => 170, :height => 50 do
          draw_bounds_debug
          font_size 10
          document_type = main_document_type
          text "<font size='16'><b>#{document_type}</b></font> N°" + @main_document.tracking_id,
            :inline_format => true,
            :align => :right
          font_size 11.5
          text @id_card.city.to_s + ' le ' + french_date(@main_document.date), :align => :right
        end
      end

      def build_contact_infos
        bounding_box [50, 585], :width => 235, :height => 50 do
          draw_bounds_debug
          font_size 10
          text '<b>Contact :</b> ' + @id_card.contact_full_name.to_s, :inline_format => true
          text '<b>Tél :</b> ' + @id_card.contact_phone.to_s, :inline_format => true
          text '<b>Fax:</b> ' + @id_card.contact_fax.to_s, :inline_format => true
          text '<b>Email:</b> ' + @id_card.contact_email.to_s, :inline_format => true
        end
      end

      def build_customer_infos
        unless @main_document.customer.nil?
          bounding_box [50, 530], :width => 420, :height => 105 do
            draw_bounds_debug
            font_size 11.5
            text 'A l’attention de :', :style => :bold
            text @main_document.customer.name
            text @main_document.customer.address.street
            text @main_document.customer.address.street_bis
            text @main_document.customer.address.zip.to_s + ' ' + @main_document.customer.address.city.to_s
            text @main_document.customer.address.country
          end
        end
      end

      def build_label
        bounding_box [50, 425], :width => 350, :height => 30 do
          draw_bounds_debug
          font_size 11
          text '<b>Objet :</b> ' + @main_document.label, :inline_format => true
        end
      end

      def build_table
        bounding_box [50, 400], :width => 450 do
        @table_matrix = [['Prestation', 'Prix unitaire', 'Quantité', 'Total HT']]
        build_lines
        build_synthesis
        build_expiry
        build_payment_terms
        build_bank_infos
        end
      end

      def build_lines
        @main_document.lines.each do |line|
          @table_matrix.push [line.label, french_number(euros(line.unit_price), 2),
          french_number(line.quantity),
          french_number(euros(line.total), 2)]
        end
      end

      def build_synthesis
        font_size 10
          @table_matrix.push ['Net HT', '', '', euros(@main_document.total_duty)]
          vat_rate = french_number(@main_document.vat_rate)
          @table_matrix.push ["TVA #{vat_rate} %", '', '', euros(@main_document.vat_amount)]
          @table_matrix.push ['Total TTC', '', '', euros(@main_document.total_all_taxes)]
          if (@main_document.advance && @main_document.advance != 0.0)
            @table_matrix.push ['Acompte reçu sur commande', '', '', euros(@main_document.advance)]
            @table_matrix.push ['Solde à payer', '', '', euros(@main_document.balance)]
          end
          write_table_from_matrix(@table_matrix)
        end

      def build_payment_terms
        move_down 15
        text 'Conditions de paiement :'
        text @main_document.payment_term.try(:label)
      end

      def build_bank_infos
        move_down 10
        text 'Coordonnées bancaires :'
        text 'IBAN : ' + @id_card.iban.to_s
        text 'BIC / SWIFT : ' + @id_card.bic_swift.to_s
      end

      def build_expiry
      end

      def build_comments
      end

      def build_footer
        bounding_box [50, 37], :width => 425 do
          font "Times-Roman"
          font_size 8.5
          text @id_card.custom_info_1, :color => GREY
        end
      end


      def write_table_from_matrix matrix
          table matrix,
        :column_widths => [215, 65, 60, 80],
        :cell_style => {:align => :right, :border_width => 0.5} do
          row(0).style :background_color => LIGHT_GREY # make first row grey
          row(0).style :size => 11
          # reduce font size of invoice lines
          invoice_lines_range = Range.new(1,(matrix.length - 6))
          row(invoice_lines_range).style :size => 9
        end
      end

      def draw_bounds_debug
        transparent(0.5) { stroke_bounds } if DEBUG
      end

      def write_legal_line text
        text text, :align => :right, :color => GREY
      end

      def french_date date
        date
        french_month = FRENCH_MONTH_NAMES[date.month]
        return date.day.to_s + ' ' + french_month + ' ' + date.year.to_s
      end

      def euros amount
        amount ||= 0
        french_number(amount, 2).to_s + " €"
      end

      def french_number amount, precision = -1
        if precision >= 0
          number_with_precision(amount, :precision => precision, :delimiter => '.', :separator => ",")
        else
          number_with_delimiter(amount, :delimiter => '.', :separator => ",")
        end
      end

      def number_without_trailling_zero number
        return ("%g" % number)
      end

    end # InvoicePdf
  end # BillingMachine
end # Dorsale
