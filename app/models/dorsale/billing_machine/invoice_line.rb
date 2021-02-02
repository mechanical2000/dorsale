class Dorsale::BillingMachine::InvoiceLine < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_billing_machine_invoice_lines"

  belongs_to :invoice, inverse_of: :lines

  validates :invoice, presence: true

  default_scope -> {
    order(position: :asc, created_at: :asc, id: :asc)
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

  after_save :update_invoice_total

  def update_invoice_total
    invoice.reload.save!
  end
end
