class Dorsale::ExpenseGun::Expense < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_expense_gun_expenses"
  include AASM

  has_many :expense_lines, inverse_of: :expense, dependent: :destroy, class_name: "Dorsale::ExpenseGun::ExpenseLine"

  has_many :attachments,
    :as         => :attachable,
    :dependent  => :destroy,
    :class_name => "Dorsale::Alexandrie::Attachment"

  belongs_to :user
  validates :user, presence: true

  validates :name, presence: true
  validates :date, presence: true

  accepts_nested_attributes_for :expense_lines,
    :allow_destroy => true,
    :reject_if => proc { |attr| attr["name"].blank? }

  default_scope -> {
    order(created_at: :desc, id: :desc)
  }

  def assign_default_values
    assign_default :date, Date.current
  end

  # Sum of line amounts
  def total_all_taxes
    expense_lines.map(&:total_all_taxes).sum
  end

  # Sum of line emplee payback
  def total_employee_payback
    expense_lines.map(&:employee_payback).sum
  end

  # Sum of deductible deductible vat
  def total_vat_deductible
    expense_lines.map(&:total_vat_deductible).sum
  end

  delegate :current_state, to: :aasm

  aasm(column: :state, whiny_transitions: false) do
    state :draft, initial: true
    state :submitted
    state :accepted
    state :refused
    state :canceled

    event :go_to_submitted do
      transitions from: :draft, to: :submitted
    end

    event :go_to_accepted do
      transitions from: :submitted, to: :accepted
    end

    event :go_to_refused do
      transitions from: :submitted, to: :refused
    end

    event :go_to_canceled do
      transitions from: [:draft, :submitted, :accepted], to: :canceled
    end
  end

  def may_edit?
    current_state == :draft
  end
end
