require "prawn/measurement_extensions"

module Dorsale
  module BillingMachine
    class InvoicePdf < Prawn::Document
      include Dorsale::Alexandrie::Prawn
      include ActionView::Helpers::NumberHelper
      DEBUG = false

      GREY       = "808080"
      LIGHT_GREY = "C0C0C0"
      WHITE      = "FFFFFF"
      BLACK      = "000000"
      BLUE       = "005F9E"

      def first_column_width
        7.1.cm
      end

      def second_column_width
        2.4.cm
      end

      def third_column_width
        second_column_width
      end

      def fourth_column_width
       3.4.cm
      end

      def last_column_width
        bounds.width - first_column_width - second_column_width - third_column_width - fourth_column_width
      end

      FRENCH_MONTH_NAMES = [nil, 'janvier', 'février', 'mars', 'avril', 'mai',
        'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre']

      attr_reader :main_document

      def initialize(main_document)
        super(page_size: 'A4', margin: 1.cm)
        setup
        @main_document = main_document
        @id_card       = main_document.id_card
      end

      def header_height
        9.cm
      end

      def middle_height
        bounds.height - header_height - footer_height
      end

      def footer_height
        4.5.cm
      end

      def logo_height
        3.2.cm
      end

      def build
        build_header
        build_middle
        build_footer
      end

      def setup
        font_root = ::Dorsale::Engine.root.join("app/assets/fonts")
        font_families.update(
          "BryantPro" => {
            normal: "#{font_root}/BryantPro-Regular.ttf",
            bold:   "#{font_root}/BryantPro-Bold.ttf",
          }
        )

        font("BryantPro")
        font_size 10
      end

      def build_header
        bounding_box [0, bounds.top], width: bounds.width, height: header_height do
          draw_bounds_debug
          build_title
          build_logo
          build_contact
          build_subject
          build_customer
        end
      end

      def build_title
        top    = bounds.top - 1.5.cm
        left   = bounds.left
        width  = bounds.width
        height = 1.cm
        bounding_box [left, top], width: width, height: height do
          draw_bounds_debug
          text "<b>#{main_document_type}", inline_format: true, size: 20, align: :center
        end
      end

      def build_logo
        width = 3.2.cm
        height = logo_height
        bounding_box [bounds.left, bounds.top], width: width, height: height do
          draw_bounds_debug
          if @main_document.id_card.logo.present?
            image @main_document.id_card.logo.path, width: (bounds.width - 1.cm)
          end
        end
      end

      def build_contact
        top    = bounds.top - 4.cm
        left   = bounds.left
        width  = bounds.width / 2 - 1.1.cm
        height = 2.3.cm

        bounding_box [left, top], width: width, height: height do
          draw_bounds_debug
          text "<b>#{@id_card.entity_name}</b>", inline_format: true if @id_card.entity_name.present?
          address_line = [@id_card.address1,@id_card.address2, @id_card.zip, @id_card.city].select(&:present?).join(", ")
          text "<b>#{address_line} </b>", inline_format: true
          text " "
          text "<b>#{I18n.t("pdfs.your_contact")} : #{@id_card.contact_full_name}</b>", inline_format: true if @id_card.contact_full_name.present?
          text "<b>#{I18n.t("pdfs.contact_phone")}</b>  #{@id_card.contact_phone}", inline_format: true if @id_card.contact_phone.present?
          text "<b>#{I18n.t("pdfs.contact_fax")}</b> #{@id_card.contact_fax}",   inline_format: true if @id_card.contact_fax.present?
          text "<b>#{I18n.t("pdfs.contact_email")}</b> #{@id_card.contact_email}",   inline_format: true if @id_card.contact_email.present?
        end
      end

      def build_subject
        top    = bounds.top - 7.5.cm
        left   = bounds.left
        width  = bounds.width / 2 - 1.1.cm
        height = 1.cm

        bounding_box [left, top], width: width, height: height do
          draw_bounds_debug
          text "<b>#{I18n.t("pdfs.subject")}</b> #{@main_document.label}",   inline_format: true if @main_document.label.present?
        end
      end

      def build_customer
        top    = bounds.top - 4.cm
        left   = bounds.width / 2 + 1.1.cm
        width  = bounds.width / 2 - 1.1.cm
        height = 4.5.cm

        bounding_box [left, top], width: width, height: height do
          draw_bounds_debug
          stroke do
            fill_color LIGHT_GREY
            fill_rounded_rectangle [cursor-bounds.height,cursor], bounds.width, bounds.height, 0
            fill_color BLACK
          end

          table_customer = []

          if @main_document.tracking_id.present?
            table_customer << [I18n.t("pdfs.tracking_number") , @main_document.tracking_id.to_s]
          end
          if @main_document.date.present?
            table_customer << [I18n.t("pdfs.date") , french_date(@main_document.date)]
          end
          if @main_document.customer.present?
            name = "#{@main_document.customer.name}\n" if @main_document.customer.name.present?
            street = "#{@main_document.customer.address.street}\n" if @main_document.customer.address.street?
            street_bis = "#{@main_document.customer.address.street_bis}\n" if @main_document.customer.address.street_bis.present?
            zip_country = "#{@main_document.customer.address.zip} #{@main_document.customer.address.city}" if @main_document.customer.address.city.present?
            table_customer << [I18n.t("pdfs.customer") , "#{name} #{street} #{street_bis} #{zip_country}" ] if @main_document.customer.name.present?
          end

          table table_customer,
          :column_widths => [ width / 3 , width - (width / 3)],
          :cell_style    => {border_width: [0, 0, 0.5, 0], padding: [2.mm, 2.mm]} do
            row(2).border_width = 0
            column(0).font_style    = :bold
            column(1).row(2).valign = :center
          end
        end
      end

      def build_middle
        left   = bounds.left
        top    = bounds.top - header_height
        width  = bounds.width - left

        bounding_box [left, top], width: width, height: 9.5.cm do
          draw_bounds_debug
          build_table
        end

        bounding_box [left, top - 10.3.cm], width: width, height: middle_height - 9.5.cm do
          draw_bounds_debug
          build_total
        end
      end

      def main_document_type
        "Facture"
      end

      def build_table
        table_products = [[I18n.t("pdfs.designation"),
          I18n.t("pdfs.quantity"),
          I18n.t("pdfs.unity"),
          I18n.t("pdfs.unit_price"),
          I18n.t("pdfs.line_total")]]


        @main_document.lines.each do |line|
          table_products.push [line.label,
              french_number(line.quantity),
              line.unit,
              french_number(euros(line.unit_price), 2),
              french_number(euros(line.total), 2)]
        end


        float do
            table [ ['','', '', '' , '']],
                :column_widths => [first_column_width, second_column_width, third_column_width, fourth_column_width, last_column_width],
                :cell_style => {:height => 9.5.cm}
          end

        table table_products,
          :column_widths => [first_column_width, second_column_width, third_column_width, fourth_column_width, last_column_width],
          :cell_style    => {border_width: 0} do
            row(0).style :text_color       => BLACK
            row(0).style :font_style       => :bold

            cells.style do |c|
              c.align = c.column == 0 ? :left : :right
            end
          end
      end

      def build_total
        table_totals = []

        if @main_document.try(:commercial_discount) && @main_document.commercial_discount != 0.0
          table_totals.push ['Remise commerciale', euros(@main_document.commercial_discount)]
        end
        table_totals.push ['Net HT', euros(@main_document.total_duty)]
        vat_rate = french_number(@main_document.vat_rate)
        table_totals.push ["TVA #{vat_rate} %", euros(@main_document.vat_amount)]
        table_totals.push ['Total TTC', euros(@main_document.total_all_taxes)]

        if @main_document.try(:advance) && @main_document.advance != 0.0
          table_totals.push ['Acompte reçu sur commande', euros(@main_document.advance)]
          table_totals.push ['Solde à payer', euros(@main_document.balance)]
        end

        table table_totals,
          :column_widths => [fourth_column_width, last_column_width],
          :cell_style    => {border_width: 1},
          :position      => :right do

            cells.style do |c|
              if c.column == 0
                c.text_color       = BLACK
              end

              c.align = :right
            end
        end
      end

      def build_comments
      end

      def build_footer
        top = bounds.bottom + footer_height

        bounding_box [0, top], width: bounds.width, height: footer_height do
          draw_bounds_debug

          left  = bounds.left
          width = bounds.width - left

          bounding_box [left, bounds.top], width: width, height: bounds.height do
            draw_bounds_debug
            build_payment_conditions
            build_bank_informations
            builds_legals
            builds_id_card_informations
          end
        end
      end

      def build_payment_conditions
        height = 2.cm
        width  = bounds.width / 2 - 2.cm

        bounding_box [bounds.left, bounds.top], height: height, width: width do
          draw_bounds_debug
          text "Conditions de paiement :", style: :bold
          text @main_document.payment_term.try(:label)
        end
      end

      def build_bank_informations
        height = 2.cm
        width  = bounds.width / 2 + 2.cm
        left   = width - 4.cm

        bounding_box [left, bounds.top], height: height, width: width do
          draw_bounds_debug
          text 'Coordonnées bancaires :', style: :bold
          text "IBAN : #{@id_card.iban}"
          text "BIC / SWIFT : #{@id_card.bic_swift}"
        end
      end

      def builds_legals
        text @id_card.custom_info_1, color: GREY
      end

      def builds_id_card_informations
        height = 15.mm
        width1 = bounds.width / 3 - 2.5.mm
        width2 = bounds.width / 3 + 5.0.mm
        width3 = bounds.width / 3 - 2.5.mm
        left1  = 0
        left2  = width1
        left3  = width1 + width2
        top    = bounds.bottom + height

        fill_color BLUE
        font_size 9

        bounding_box [left1, top], height: height, width: width1 do
          draw_bounds_debug
          text @id_card.address1.to_s
          text @id_card.zip.to_s + " " + @id_card.city.to_s
          text "www.agilidee.com"
        end

        bounding_box [left2, top], height: height, width: width2 do
          draw_bounds_debug
          text "RCS " + @id_card.registration_city.to_s + ' ' + @id_card.registration_number.to_s
          text 'SIRET ' + @id_card.siret.to_s
          text 'TVA ' + @id_card.intracommunity_vat.to_s
        end

        bounding_box [left3, top], height: height, width: width3 do
          draw_bounds_debug
          text @id_card.legal_form.to_s
          text ' au capital de ' + number_with_delimiter(@id_card.capital, :delimiter => '.').to_s + ' €'
          text 'APE ' + @id_card.ape_naf.to_s
        end
      end

      def draw_bounds_debug
        transparent(0.5) { stroke_bounds } if DEBUG
      end

      def french_date date
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

    end
  end
end