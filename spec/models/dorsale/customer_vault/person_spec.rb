require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::Person, type: :model do
  describe '#links' do
    let!(:c)     { create(:customer_vault_corporation) }
    let!(:i)     { create(:customer_vault_individual)  }
    let!(:link) { create(:customer_vault_link, alice: c, bob: i, title: 'a') }

    it "should return links" do
      expect(c.links).to eq [link]
      link = c.links.first
      expect(link.person).to eq c
      expect(link.other_person).to eq i

      expect(i.links).to eq [link]
      link = i.links.first
      expect(link.person).to eq i
      expect(link.other_person).to eq c
    end

    describe '#destroy' do
      it "should destroy links" do
        c.destroy
        expect { link.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end # describe '#links'

  it "should return self_and_related_events" do
    corporation       = create(:customer_vault_corporation)
    individual        = create(:customer_vault_individual, corporation: corporation)
    corporation_event = create(:customer_vault_event, person: corporation)
    individual_event  = create(:customer_vault_event, person: individual)

    expect(corporation.self_and_related_events).to contain_exactly(corporation_event, individual_event)
    expect(individual.self_and_related_events).to contain_exactly(individual_event)
  end

  describe "address" do
    let(:person_without_address) {
      corporation = Dorsale::CustomerVault::Corporation.create!(name: "agilidée")
      corporation.address.destroy
      corporation
    }

    it "should auto create address on build" do
      corporation = Dorsale::CustomerVault::Corporation.new
      expect(corporation.address).to be_present
    end

    it "should NOT auto create address on find" do
      corporation = Dorsale::CustomerVault::Corporation.find(person_without_address.id)
      expect(corporation.address).to be_nil
    end

    it "should auto create address before validation" do
      corporation = Dorsale::CustomerVault::Corporation.find(person_without_address.id)
      expect(corporation.address).to be_nil

      corporation.save!
      expect(corporation.address).to be_present
    end
  end # describe "address"
end
