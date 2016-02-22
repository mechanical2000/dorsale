module Dorsale
  module ExpenseGun
    class ExpenseLine < ActiveRecord::Base
      self.table_name = "dorsale_expense_gun_expense_lines"
      belongs_to :expense, class_name: ::Dorsale::ExpenseGun::Expense
      belongs_to :category, class_name: ::Dorsale::ExpenseGun::Category

      def initialize(h = {})
        super({company_part: 100}.merge(h))
      end

      validates :expense,         presence: true
      validates :name,            presence: true
      validates :date,            presence: true
      validates :category,        presence: true
      validates :total_all_taxes, presence: true, numericality: {greater_than_or_equal_to: 1.0}
      validates :vat,             presence: true, numericality: {greater_than_or_equal_to: 0}
      validates :company_part,    presence: true, numericality: {greater_than_or_equal_to: 1.0, less_than_or_equal_to: 100.0}

      # simple_form
      validates :category_id, presence: true

      def employee_payback
        (total_all_taxes * company_part / 100)
      end

      def total_vat_deductible
        category.vat_deductible == true ? (vat * company_part / 100) : 0.0
      end
    end
  end
end