require 'rails_helper'

RSpec.describe ::Dorsale::ExpenseGun::Expense, type: :model do
  it "expense factory should be valid?" do
    expect(build(:expense_gun_expense)).to be_valid
  end

  it "shoud validates presence of name" do
    expect(build(:expense_gun_expense)).to validate_presence_of :name
  end

  it "shoud validates presence of date" do
    expect(build(:expense_gun_expense)).to validate_presence_of :date
  end

  it "default #date should be tody" do
    expect(::Dorsale::ExpenseGun::Expense.new.date).to eq Date.today
  end

  it "new expense should have new state" do
    expect(::Dorsale::ExpenseGun::Expense.new.current_state).to be :new
  end

  describe "new state" do
    before :each do
      @expense = build(:expense_gun_expense)
    end

    it "new expense can be submited" do
      expect(@expense.submit).to be true
      expect(@expense.current_state).to be :submited
    end

    it "new expense can't be accepted" do
      expect(@expense.accept).to be false
      expect(@expense.current_state).to be :new
    end

    it "new expense can't be refused" do
      expect(@expense.refuse).to be false
      expect(@expense.current_state).to be :new
    end

    it "new expense can be canceled" do
      expect(@expense.cancel).to be true
      expect(@expense.current_state).to be :canceled
    end
  end

  describe "submited state" do
    before :each do
      @expense = FactoryGirl.build(:expense_gun_expense)
      @expense.submit
    end

    it "submitted expense can be accepted" do
      expect(@expense.accept).to be true
      expect(@expense.current_state).to be :accepted
    end

    it "submitted expense can be refused" do
      expect(@expense.refuse).to be true
      expect(@expense.current_state).to be :refused
    end

    it "submitted expense can be canceled" do
      expect(@expense.cancel).to be true
      expect(@expense.current_state).to be :canceled
    end
  end

  describe "acceped state" do
    before :each do
      @expense = FactoryGirl.build(:expense_gun_expense)
      @expense.submit
      @expense.accept
    end

    it "acceped expense can't be submited" do
      expect(@expense.submit).to be false
      expect(@expense.current_state).to be :accepted
    end

    it "acceped expense can't be refused" do
      expect(@expense.refuse).to be false
      expect(@expense.current_state).to be :accepted
    end

    it "acceped expense can be canceled" do
      expect(@expense.cancel).to be true
      expect(@expense.current_state).to be :canceled
    end
  end

  describe "refused state" do
    before :each do
      @expense = build(:expense_gun_expense)
      @expense.submit
      @expense.refuse
    end

    it "refused expense can't be submited" do
      expect(@expense.submit).to be false
      expect(@expense.current_state).to be :refused
    end

    it "refused expense can't be acceped" do
      expect(@expense.accept).to be false
      expect(@expense.current_state).to be :refused
    end

    it "refused expense can't be canceled" do
      expect(@expense.cancel).to be false
      expect(@expense.current_state).to be :refused
    end
  end

  describe "canceled state" do
    before :each do
      @expense = FactoryGirl.build(:expense_gun_expense)
      @expense.cancel
    end

    it "canceled expense can't be submited" do
      expect(@expense.submit).to be false
      expect(@expense.current_state).to be :canceled
    end

    it "canceled expense can't be acceped" do
      expect(@expense.accept).to be false
      expect(@expense.current_state).to be :canceled
    end

    it "canceled expense can't be refused" do
      expect(@expense.refuse).to be false
      expect(@expense.current_state).to be :canceled
    end
  end

  it "#total_all_taxes should return sum of lines" do
    expense = build(:expense_gun_expense, expense_lines: [])
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10)
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10)
    expect(expense.total_all_taxes).to eq 20.0
  end

  it "#total_employee_payback should return sum of lines" do
    expense = FactoryGirl.build(:expense_gun_expense, expense_lines: [])
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10, company_part: 100)
    expense.expense_lines << build(:expense_gun_expense_line, total_all_taxes: 10, company_part: 50)
    expect(expense.total_employee_payback).to eq 15.0
  end

  it "#total_vat_deductible should return sum of lines" do
    expense = build(:expense_gun_expense, expense_lines: [])
    category1 = build(:expense_gun_category, vat_deductible: true)
    category2 = build(:expense_gun_category, vat_deductible: false)
    expense.expense_lines << build(:expense_gun_expense_line, vat: 10, category: category1, company_part: 50)
    expense.expense_lines << build(:expense_gun_expense_line, vat: 10, category: category2, company_part: 50)
    expect(expense.total_vat_deductible).to eq 5.0
  end

  it "#may_edit? should return false unless expense is not submited" do
    expect(::Dorsale::ExpenseGun::Expense.new(state: :new).may_edit?).to be true
    expect(::Dorsale::ExpenseGun::Expense.new(state: :submited).may_edit?).to be false
    expect(::Dorsale::ExpenseGun::Expense.new(state: :acceped).may_edit?).to be false
    expect(::Dorsale::ExpenseGun::Expense.new(state: :refused).may_edit?).to be false
    expect(::Dorsale::ExpenseGun::Expense.new(state: :canceled).may_edit?).to be false
  end

  it "destroy an expense should destroy associated expense lines" do
    expense          = create(:expense_gun_expense)
    expense_line_ids = expense.expense_lines.map(&:id)
    expect(expense_line_ids.any?).to be true
    expense.destroy
    expense_line_ids.map do |id|
      expect(::Dorsale::ExpenseGun::ExpenseLine.exists?(id)).to be false
    end
  end
end