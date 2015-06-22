require "rails_helper"

describe ::Ability do
  let(:ability){
    ::Ability.new
  }

  it { expect(ability).to be_able_to(:create, ::Dorsale::Comment) }
  it { expect(ability).to be_able_to(:delete, ::Dorsale::Comment) }
  it { expect(ability).to be_able_to(:update, ::Dorsale::Comment) }
end
