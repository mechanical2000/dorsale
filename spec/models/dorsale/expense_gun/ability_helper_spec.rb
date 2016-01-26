require "rails_helper"

describe ::Ability do
  let(:ability){
    Ability.new
  }

  it { expect(ability).to be_able_to(:list, ::Dorsale::ExpenseGun::Expense) }
  it { expect(ability).to be_able_to(:create, ::Dorsale::ExpenseGun::Expense) }
  it { expect(ability).to be_able_to(:show, ::Dorsale::ExpenseGun::Expense) }
  it { expect(ability).to be_able_to(:edit, ::Dorsale::ExpenseGun::Expense) }
  it { expect(ability).to be_able_to(:submit, ::Dorsale::ExpenseGun::Expense) }
  it { expect(ability).to be_able_to(:accept, ::Dorsale::ExpenseGun::Expense) }
  it { expect(ability).to be_able_to(:refuse, ::Dorsale::ExpenseGun::Expense) }
  it { expect(ability).to be_able_to(:cancel, ::Dorsale::ExpenseGun::Expense) }
end