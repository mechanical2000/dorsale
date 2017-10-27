class Dorsale::BillingMachine::InvoiceSingleVatPdf < Dorsale::ApplicationPdf
  include Dorsale::Alexandrie::Prawn::RenderWithAttachments

  def attachments
    @main_document.try(:attachments) || []
  end

  DEBUG = false

  BLACK      = "000000"
  WHITE      = "FFFFFF"
  GREY       = "808080"
  LIGHT_GREY = "C0C0C0"

  def bm_currency(n)
    currency(n, Dorsale::BillingMachine.default_currency)
  end

  attr_reader :main_document

  def initialize(main_document)
    super(page_size: "A4", margin: 1.cm)
    @main_document = main_document
    setup
  end

  # rubocop:disable Style/SingleLineMethods, Layout/EmptyLineBetweenDefs
  def header_height;         90.mm; end
  def logo_height;           32.mm; end
  def logo_width;            50.mm; end
  def contact_infos_height;  30.mm; end

  def footer_height;           40.mm; end
  def footer_top_height;       15.mm; end
  def footer_bottom_height;    15.mm; end
  def footer_pagination_height; 5.mm; end

  def middle_height;         14.cm; end
  def products_table_height; 90.mm; end

  def first_column_width;  7.6.cm; end
  def second_column_width; 2.4.cm; end
  def third_column_width;  2.5.cm; end
  def fourth_column_width; 2.9.cm; end
  # rubocop:enable Style/SingleLineMethods, Layout/EmptyLineBetweenDefs

  def last_column_width
    bounds.width - first_column_width - second_column_width - third_column_width - fourth_column_width
  end

  def build
    repeat :all do
      build_header
      build_footer
    end

    build_middle
    build_page_numbers
  end

  def setup
    font_root = ::Dorsale::Engine.root.join("app/assets/fonts")
    font_families.update( # rubocop:disable Rails/SaveBang
      "BryantPro" => {
        normal: "#{font_root}/BryantPro-Regular.ttf",
        bold:   "#{font_root}/BryantPro-Bold.ttf",
      },
    )

    font("BryantPro")
    font_size 10
  end

  def build_header
    bb height: header_height do
      build_title
      build_logo
      build_contact_infos
      build_subject
      build_customer
    end
  end

  def build_title
    top    = bounds.top - 1.5.cm
    height = 1.cm

    title = "<b>#{main_document.t} n° #{main_document.tracking_id}</b>"

    bb top: top, height: height do
      tb title, size: 20, align: :center
    end
  end

  def logo_path
  end

  def build_logo
    height = logo_height
    width  = logo_width

    bb width: width, height: height do
      image logo_path, fit: [width, height] if logo_path
    end
  end

  def contact_infos_content
    placeholder __method__
  end

  def build_contact_infos
    top    = bounds.top - 4.cm
    width  = bounds.width / 2 - 1.1.cm
    height = contact_infos_height

    bb top: top, width: width, height: height do
      tb contact_infos_content.to_s, size: 9
    end
  end

  def build_subject
    top    = bounds.top - 7.5.cm
    width  = bounds.width / 2 - 1.1.cm
    height = 15.mm

    bb top: top, width: width, height: height do
      if main_document.label.present?
        text "<b>#{main_document.t(:label)} : </b> #{main_document.label}", inline_format: true
      end

      if main_document.date.present?
        move_down 3.mm
        text "<b>#{main_document.t(:date)} : </b> #{date main_document.date}", inline_format: true
      end
    end
  end

  def customer_content
    return if main_document.customer.nil?

    content = []
    content << main_document.customer.name
    content << main_document.customer.address.street
    content << main_document.customer.address.street_bis
    content << "#{main_document.customer.address.zip} #{main_document.customer.address.city}"
    content << main_document.customer.address.country

    if main_document.customer.try(:european_union_vat_number).present?
      content << main_document.customer.t(:european_union_vat_number) + " : "
      content << main_document.customer.european_union_vat_number
    end

    content.select(&:present?).join("\n")
  end

  def build_customer
    top     = bounds.top - 4.cm
    left    = bounds.width / 2 + 1.1.cm
    width   = bounds.width / 2 - 1.1.cm
    height  = 4.5.cm
    padding = 3.mm

    bb top: top, left: left, height: height, width: width, padding: padding, background: LIGHT_GREY do
      tb customer_content.to_s
    end
  end # def build_customer

  def build_middle
    top    = bounds.top - header_height
    height = middle_height

    bb top: top, height: height do
      build_table
      build_total
      build_document_infos
    end
  end

  def has_advance
    main_document.try(:advance) && main_document.advance != 0.0
  end

  def has_discount
    main_document.try(:commercial_discount) && main_document.commercial_discount != 0.0
  end

  def build_table
    height = products_table_height

    # Empty table to draw lines
    bb height: products_table_height do
      repeat :all do
        float do
          table [["", "", "", "", ""]],
            :column_widths => [
              first_column_width,
              second_column_width,
              third_column_width,
              fourth_column_width,
              last_column_width,
            ],
            :cell_style => {height: height} \
          do
            row(0).style       :text_color => BLACK
            row(0).style       :font_style => :bold
            column(0).style    :align      => :left
            column(1..4).style :align      => :right
          end # table
        end # float
      end # repeat all
    end # bb

    # Products table
    bb height: height do
      table_products = [[
        main_document.t(:designation).mb_chars.upcase.to_s,
        main_document.t(:quantity).mb_chars.upcase.to_s,
        main_document.t(:unit).mb_chars.upcase.to_s,
        main_document.t(:unit_price).mb_chars.upcase.to_s,
        main_document.t(:line_total).mb_chars.upcase.to_s,
      ]]

      main_document.lines.each do |line|
        table_products.push [
          line.label,
          number(line.quantity).gsub(",00", "").gsub(".00", ""),
          line.unit,
          bm_currency(line.unit_price),
          bm_currency(line.total),
        ]
      end

      table table_products,
        :column_widths => [
          first_column_width,
          second_column_width,
          third_column_width,
          fourth_column_width,
          last_column_width,
        ],
        :header => true,
        :cell_style => {border_width: 0} \
      do
        row(0).font_style = :bold
        row(0).border_width =
          1,
          cells.style { |c| c.align = c.column.zero? ? :left : :right }
      end # table
    end # bb
  end # build_table

  def build_total
    top    = bounds.top - products_table_height - 5.mm
    height = middle_height - products_table_height - 5.mm

    bb top: top, height: height do
      table_totals = [[]]

      if has_discount
        table_totals.push [
          main_document.t(:commercial_discount).mb_chars.upcase.to_s,
          bm_currency(-main_document.commercial_discount),
        ]
      end

      table_totals.push [
        main_document.t(:total_excluding_taxes).mb_chars.upcase.to_s,
        bm_currency(main_document.total_excluding_taxes),
      ]

      vat_rate = number(main_document.vat_rate)
      table_totals.push [
        "#{main_document.t(:vat).mb_chars.upcase} #{percentage vat_rate}",
        bm_currency(main_document.vat_amount),
      ]

      if has_advance
        table_totals.push [
          main_document.t(:advance).mb_chars.upcase.to_s,
          bm_currency(main_document.advance),
        ]

        table_totals.push [
          main_document.t(:total_including_taxes).mb_chars.upcase.to_s,
          bm_currency(main_document.balance),
        ]
      else
        table_totals.push [
          main_document.t(:total_including_taxes).mb_chars.upcase.to_s,
          bm_currency(main_document.total_including_taxes),
        ]
      end

      table table_totals,
        :column_widths => [fourth_column_width, last_column_width],
        :cell_style    => {border_width: [0, 1, 0, 0]},
        :position      => :right do
          row(-1).style :font_style => :bold
          column(0).padding_right = 0.2.cm
          row(-1).borders = [:top, :right]
          row(-1).border_width = 1
          cells.style do |c|
            c.align = :right
          end
        end

      stroke do
        rectangle [(bounds.right - fourth_column_width - last_column_width), bounds.top], (fourth_column_width + last_column_width), (bounds.top-cursor)
      end
    end
  end

  def document_infos_content
    txt = []

    if main_document.try(:payment_term).present?
      txt << "<b>#{main_document.t :payment_term}</b> : #{main_document.payment_term}"
    end

    if main_document.try(:expires_at).present?
      txt << "<b>#{main_document.t :expires_at}</b> : #{date main_document.expires_at}"
    end

    txt << main_document.comments

    txt.select(&:present?).join("\n\n")
  end

  def build_document_infos
    top    = bounds.top - products_table_height - 5.mm
    height = middle_height - products_table_height - 5.mm
    width  = 10.cm

    btb document_infos_content, top: top, height: height, width: width
  end

  def build_footer
    top    = bounds.bottom + footer_height
    height = footer_height

    bb top: top, height: height do
      build_footer_top
      build_footer_line
      build_footer_bottom
    end
  end

  # TODO
  def footer_top_content
    placeholder __method__
  end

  def build_footer_top
    btb footer_top_content, height: footer_top_height, size: 9
  end

  def build_footer_line
    top = bounds.top - footer_top_height - (footer_height - footer_top_height - footer_bottom_height - footer_pagination_height) / 2
    stroke do
      horizontal_line bounds.left, bounds.right, at: top
    end
  end

  def footer_bottom_content
    placeholder __method__
  end

  def build_footer_bottom
    height = footer_bottom_height
    top    = bounds.bottom + height + footer_pagination_height

    btb footer_bottom_content, top: top, height: height, size: 9
  end

  def build_page_numbers
    height = footer_pagination_height
    top    = bounds.bottom + height

    bb top: top, height: height do
      number_pages "page <page>/<total>", align: :right, size: 9
    end
  end
end
