require "rails_helper"

RSpec.describe Dorsale::ExpenseGun::Expense, type: :model do
  it { is_expected.to have_many(:expense_lines).dependent(:destroy) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :date }

  it "expense factory should be valid?" do
    expect(build(:expense_gun_expense)).to be_valid
  end

  it "default #date should be tody" do
    expect(described_class.new.date).to eq Date.current
  end

  it "new expense should have new state" do
    expect(described_class.new.state).to eq "draft"
  end

  it "#total_all_taxes should return sum of lines" do
    expense = build(:expense_gun_expense, expense_lines: [])
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10)
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10)
    expect(expense.total_all_taxes).to eq 20.0
  end

  it "#total_employee_payback should return sum of lines" do
    expense = build(:expense_gun_expense, expense_lines: [])

    line1 = build(:expense_gun_expense_line, total_all_taxes: 10, company_part: 100)
    expense.expense_lines << line1

    line2 = build(:expense_gun_expense_line, total_all_taxes: 10, company_part: 50)
    expense.expense_lines << line2

    expect(expense.total_employee_payback).to eq 15.0
  end

  it "#total_vat_deductible should return sum of lines" do
    expense = build(:expense_gun_expense, expense_lines: [])

    category1 = build(:expense_gun_category, vat_deductible: true)
    line1 = build(:expense_gun_expense_line, vat: 10, category: category1, company_part: 50)
    expense.expense_lines << line1

    category2 = build(:expense_gun_category, vat_deductible: false)
    line2 = build(:expense_gun_expense_line, vat: 10, category: category2, company_part: 50)
    expense.expense_lines << line2

    expect(expense.total_vat_deductible).to eq 5.0
  end
end
