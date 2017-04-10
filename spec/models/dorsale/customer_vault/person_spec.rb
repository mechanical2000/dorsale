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

  it "should return self_and_related_comments" do
    corporation         = create(:customer_vault_corporation)
    individual          = create(:customer_vault_individual, corporation: corporation)
    corporation_comment = create(:dorsale_comment, commentable: corporation)
    individual_comment  = create(:dorsale_comment, commentable: individual)

    expect(corporation.self_and_related_comments).to contain_exactly(corporation_comment, individual_comment)
    expect(individual.self_and_related_comments).to contain_exactly(individual_comment)
  end

end
