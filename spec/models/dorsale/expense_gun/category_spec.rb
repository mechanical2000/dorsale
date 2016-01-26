require 'rails_helper'

RSpec.describe ::Dorsale::ExpenseGun::Category, type: :model  do
  it "category factory should be valid?" do
    expect(FactoryGirl.build(:expense_gun_category)).to be_valid
  end

  it "#name should be present" do
    expect(FactoryGirl.build(:expense_gun_category)).to validate_presence_of :name
  end
end