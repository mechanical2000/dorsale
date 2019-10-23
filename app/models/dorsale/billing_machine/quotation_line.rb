class Dorsale::BillingMachine::QuotationLine < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_billing_machine_quotation_lines"

  belongs_to :quotation, inverse_of: :lines

  validates :quotation, presence: true

  default_scope -> {
    order(:created_at => :asc)
  }

  before_validation :update_total

  def assign_default_values
    assign_default :quantity,   0
    assign_default :unit_price, 0
    assign_default :vat_rate,   ::Dorsale::BillingMachine.default_vat_rate
  end

  def update_total
    self.total = (quantity.to_f * unit_price.to_f).round(2)
  end

  after_save :update_quotation_total

  def update_quotation_total
    quotation.reload.save!
  end
end
