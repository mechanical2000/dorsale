class Dorsale::BillingMachine::Invoice < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_billing_machine_invoices"

  belongs_to :customer, polymorphic: true
  belongs_to :payment_term

  has_many :lines, inverse_of: :invoice, dependent: :destroy, class_name: "Dorsale::BillingMachine::InvoiceLine"

  accepts_nested_attributes_for :lines, allow_destroy: true

  polymorphic_id_for :customer

  mount_uploader :pdf_file, ::Dorsale::PdfUploader

  validates :date, presence: true

  default_scope -> {
    order(unique_index: :desc)
  }

  def document_type
    :invoice
  end

  before_create :assign_unique_index
  before_create :assign_tracking_id

  def assign_unique_index
    if unique_index.nil?
      self.unique_index = self.class.all.pluck(:unique_index).max.to_i.next
    end
  end

  def assign_tracking_id
    self.tracking_id = date.year.to_s + "-" + unique_index.to_s.rjust(2, "0")
  end

  def assign_default_values
    assign_default :advance,               0.0
    assign_default :vat_amount,            0.0
    assign_default :commercial_discount,   0.0
    assign_default :total_excluding_taxes, 0.0
    assign_default :paid,                  false
  end

  after_initialize :assign_default_dates

  def assign_default_dates
    assign_default :date,     Date.current
    assign_default :due_date, Date.current + 30.days
  end

  before_save :update_totals

  def update_totals
    assign_default_values
    lines.each(&:update_total)
    apply_vat_rate_to_lines

    lines_sum = lines.map(&:total).sum.round(2)

    self.total_excluding_taxes = lines_sum - commercial_discount

    if commercial_discount.nonzero? && lines_sum.nonzero?
      discount_rate = commercial_discount / lines_sum
    else
      discount_rate = 0.0
    end

    self.vat_amount = 0.0

    lines.each do |line|
      line_total = line.total - (line.total * discount_rate)
      line_vat = (line_total * line.vat_rate / 100.0)
      line_vat = line_vat.round(2) if Dorsale::BillingMachine.vat_round_by_line
      self.vat_amount += line_vat
    end

    self.vat_amount = vat_amount.round(2)

    self.total_including_taxes = total_excluding_taxes + vat_amount
    self.balance               = total_including_taxes - advance
  end

  def vat_rate
    if ::Dorsale::BillingMachine.vat_mode == :multiple
      raise "Invoice#vat_rate is not available in multiple vat mode"
    end

    return @vat_rate if @vat_rate

    vat_rates = lines.map(&:vat_rate).uniq

    if vat_rates.length > 1
      raise "Invoice has multiple vat rates"
    end

    vat_rates.first || ::Dorsale::BillingMachine.default_vat_rate
  end

  attr_writer :vat_rate

  def apply_vat_rate_to_lines
    return if ::Dorsale::BillingMachine.vat_mode == :multiple

    lines.each do |line|
      line.vat_rate = vat_rate
    end
  end

  def payment_status
    if paid?
      :paid
    elsif due_date.nil?
      :on_alert
    elsif Date.current >= due_date + 15
      :on_alert
    elsif Date.current > due_date
      :late
    else
      :pending
    end
  end

  def t(*args)
    return super if args.any?

    if balance&.negative?
      super(:credit_note)
    else
      self.class.t
    end
  end

  # rubocop:disable Style/SingleLineMethods
  private def total_excluding_taxes=(*); super; end
  private def vat_amount=(*);            super; end
  private def total_including_taxes=(*); super; end
  private def balance=(*);               super; end
  # rubocop:enable Style/SingleLineMethods
end
