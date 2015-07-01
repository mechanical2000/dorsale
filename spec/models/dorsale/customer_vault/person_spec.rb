require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::Person, type: :model do
  describe '#links' do
    let(:c) { create(:customer_vault_corporation) }
    let(:c2) { create(:customer_vault_corporation) }
    let(:i) { create(:customer_vault_individual) }
    let(:i2) { create(:customer_vault_individual) }

    before :each do
      @l1 =  create(:customer_vault_link, alice: c, bob: c2, title: 'h')
      @l2 =  create(:customer_vault_link, alice: i, bob: c, title: 'm')
      @l3 =  create(:customer_vault_link, alice: i2, bob: i, title: 'p')
    end

    describe 'corporations' do
      it 'should return all links wether its alice or bob' do
        expect(c.links).to include({title: 'h', person: c2, origin: @l1})
        expect(c.links).to include({title: 'm', person: i, origin: @l2})

        expect(c2.links).to eq [{title: 'h', person: c, origin: @l1}]
      end
    end

    describe 'individuals' do
      it 'should return all links wether its alice or bob' do
        expect(i.links).to include({title: 'm', person: c, origin: @l2})
        expect(i.links).to include({title: 'p', person: i2, origin: @l3})

        expect(i2.links).to eq [{title: 'p', person: i, origin: @l3}]
      end
    end

    describe '#destroy individuals' do
      it "should destroy his links" do
        c.destroy
        expect{@l1.reload}.to raise_error(ActiveRecord::RecordNotFound)
        expect{@l2.reload}.to raise_error(ActiveRecord::RecordNotFound)
        expect(@l3.reload).to be_valid
      end
    end
  end
end

