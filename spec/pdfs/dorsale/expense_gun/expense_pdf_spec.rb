require "rails_helper"

describe Dorsale::ExpenseGun::ExpensePdf do
  it "should work" do
    expense = create(:expense_gun_expense_line).expense

    expect {
      described_class.new(expense).tap(&:build).render_with_attachments
    }.to_not raise_error
  end
end
