require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::Person, type: :model do
  describe "#links" do
    let!(:c)     { create(:customer_vault_corporation) }
    let!(:i)     { create(:customer_vault_individual)  }
    let!(:link) { create(:customer_vault_link, alice: c, bob: i, title: "a") }

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

    describe "#destroy" do
      it "should destroy links" do
        c.destroy!
        expect { link.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end # describe '#links'

  it "should return self_and_related_events" do
    corporation       = create(:customer_vault_corporation)
    individual        = create(:customer_vault_individual, corporation: corporation)
    corporation_event = create(:customer_vault_event, person: corporation)
    individual_event  = create(:customer_vault_event, person: individual)

    expect(corporation.self_and_related_events).to \
      contain_exactly(corporation_event, individual_event)
    expect(individual.self_and_related_events).to contain_exactly(individual_event)
  end

  describe "address" do
    let(:person_without_address) {
      corporation = Dorsale::CustomerVault::Corporation.create!(name: "agilidée")
      corporation.address.destroy!
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

  describe "emails" do
    it "should strip email" do
      individual = create(:customer_vault_individual, email: " myemail@example.org ")
      expect(individual.email).to eq "myemail@example.org"
    end

    it "should create an array of strings without blank characters" do
      test_individual = create(:customer_vault_individual, email: "primary@example.org")
      test_individual.secondary_emails_str = " first@example.org \n second@example.org "
      expect(test_individual.secondary_emails).to eq ["first@example.org", "second@example.org"]
    end

    it "should return one object in the scope" do
      individual = create(:customer_vault_individual,
        :email            => "primary@example.org",
        :secondary_emails => ["first@example.org"],
      )

      individual2 = Dorsale::CustomerVault::Person.having_email("primary@example.org")
      expect(individual2).to eq [individual]

      individual3 = Dorsale::CustomerVault::Person.having_email("first@example.org")
      expect(individual3).to eq [individual]
    end

    it "should check whether a new email address already is in the database" do
      individual = create(:customer_vault_individual,
        :email            => "primary@example.org",
        :secondary_emails => ["first@example.org", "second@example.org"],
      )

      individual2 = create(:customer_vault_individual)
      individual2.email = "primary@example.org"
      expect(individual2).to be_invalid
      expect(individual2.errors).to have_key :email
      expect(individual2.errors).to_not have_key :secondary_emails
      expect(individual2.errors).to_not have_key :secondary_emails_str

      individual3 = create(:customer_vault_individual)
      individual3.secondary_emails << "first@example.org"
      expect(individual3).to be_invalid
      expect(individual3.errors).to have_key :secondary_emails
      expect(individual3.errors).to have_key :secondary_emails_str
      expect(individual3.errors).to_not have_key :email
    end
  end # describe "emails"
end
