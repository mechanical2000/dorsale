class Dorsale::ExpenseGun::Expense < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_expense_gun_expenses"

  STATES = %w(draft pending paid canceled)

  has_many :expense_lines, inverse_of: :expense, dependent: :destroy, class_name: "Dorsale::ExpenseGun::ExpenseLine"

  has_many :attachments,
    :as         => :attachable,
    :dependent  => :destroy,
    :class_name => "Dorsale::Alexandrie::Attachment"

  belongs_to :user
  validates :user, presence: true

  validates :state, presence: true, inclusion: {in: STATES}
  validates :name, presence: true
  validates :date, presence: true

  accepts_nested_attributes_for :expense_lines,
    :allow_destroy => true,
    :reject_if => proc { |attr| attr["name"].blank? }

  default_scope -> {
    order(created_at: :desc, id: :desc)
  }

  def assign_default_values
    assign_default :state, STATES.first
    assign_default :date, Date.current
  end

  # Sum of line amounts
  def total_all_taxes
    expense_lines.sum(&:total_all_taxes)
  end

  # Sum of line emplee payback
  def total_employee_payback
    expense_lines.sum(&:employee_payback)
  end

  # Sum of deductible deductible vat
  def total_vat_deductible
    expense_lines.sum(&:total_vat_deductible)
  end
end
