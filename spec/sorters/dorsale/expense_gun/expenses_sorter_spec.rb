require "rails_helper"

describe Dorsale::ExpenseGun::ExpensesSorter do
  let!(:expense1) { create(:expense_gun_expense, date: "2021-05-10") }
  let!(:expense2) { create(:expense_gun_expense, date: "2021-05-20") }

  def sort_by(column)
    described_class.call(Dorsale::ExpenseGun::Expense.all, column)
  end

  def self.it_should_sort_by(column)
    it "should sort by #{column}" do
      expect(sort_by column.to_s).to eq [expense1, expense2]
      expect(sort_by "-#{column}").to eq [expense2, expense1]
    end
  end

  it_should_sort_by :created_at
  it_should_sort_by :date
end # describe "sorting"
