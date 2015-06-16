require "rails_helper"

describe ::Ability do
  let(:ability){
    Ability.new
  }

  it { expect(ability).to be_able_to(:create, ::Dorsale::Alexandrie::Attachment) }
  it { expect(ability).to be_able_to(:delete, ::Dorsale::Alexandrie::Attachment) }
end
