require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::PeopleController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe "#corporations" do
    render_views

    it "should return corporations only" do
      corporation = create(:customer_vault_corporation)
      individual  = create(:customer_vault_individual)
      get :corporations
      expect(assigns :people).to eq [corporation]
    end
  end # describe "#corporations"

  describe "#individuals" do
    render_views

    it "should return individuals only" do
      corporation = create(:customer_vault_corporation)
      individual  = create(:customer_vault_individual)
      get :individuals
      expect(assigns :people).to eq [individual]
    end
  end # describe "#individuals"

  describe "#list" do
    describe "sorting" do
      it "should sort people by name by default" do
        abc   = create(:customer_vault_corporation, name: "Abc Corp")
        bob   = create(:customer_vault_individual, last_name: "Bob")
        alice = create(:customer_vault_individual, last_name: "Alice")
        zorg  = create(:customer_vault_corporation, name: "Zorg Corp")

        get :index

        expect(assigns(:people)).to eq([abc, alice, bob, zorg])
      end
    end # describe "sorting"

    describe "filters" do
      it "should filter by person type" do
        individual  = create(:customer_vault_individual)
        corporation = create(:customer_vault_corporation)

        cookies[:filters] = {person_type: "Dorsale::CustomerVault::Individual"}.to_json

        get :index

        expect(assigns(:people)).to eq [individual]
      end

      it "should filter by person origin" do
        origin      = create(:customer_vault_origin)
        individual1 = create(:customer_vault_individual, origin: origin)
        individual2 = create(:customer_vault_individual)

        cookies[:filters] = {person_origin: origin.id}.to_json
        get :index

        expect(assigns(:people)).to eq [individual1]
      end

      it "should filter by person activity_type" do
        activity_type = create(:customer_vault_activity_type)
        corporation1  = create(:customer_vault_corporation, activity_type: activity_type)
        corporation2  = create(:customer_vault_corporation)

        cookies[:filters] = {person_activity: activity_type.id}.to_json
        get :index

        expect(assigns(:people)).to eq [corporation1]
      end
    end # describe "filters"

    describe "search" do
      it "search should ignore filters" do
        corporation1 = create(:customer_vault_corporation, tag_list: "abc", name: "aaa")
        corporation2 = create(:customer_vault_corporation, tag_list: "xyz", name: "bbb")
        @request.cookies["filters"] = {tags: ["abc"]}.to_json
        get :index, params: {q: "bbb"}
        expect(assigns(:people)).to eq [corporation2]
      end
    end # describe "search"
  end # describe "#list"

  describe "#create" do
    before do
      allow_any_instance_of(Dorsale::CustomerVault::PeopleController).to \
        receive(:model) { Dorsale::CustomerVault::Corporation }
    end

    it "should generate an event" do
      expect {
        post :create, params: {person: {corporation_name: "agilidée"}}
      }.to change(Dorsale::CustomerVault::Event, :count).by(1)

      event = Dorsale::CustomerVault::Event.last_created
      expect(event.author).to eq user
      expect(event.person).to eq Dorsale::CustomerVault::Person.last_created
      expect(event.action).to eq "create"
    end
  end # describe "#create"

  describe "#update" do
    before do
      allow_any_instance_of(Dorsale::CustomerVault::PeopleController).to \
        receive(:model) { Dorsale::CustomerVault::Corporation }
    end

    it "should generate an event" do
      corporation = create(:customer_vault_corporation)

      expect {
        patch :update, params: {id: corporation, person: {corporation_name: "agilidée"}}
      }.to change(Dorsale::CustomerVault::Event, :count).by(1)

      event = Dorsale::CustomerVault::Event.last_created
      expect(event.author).to eq user
      expect(event.person).to eq corporation
      expect(event.action).to eq "update"
    end
  end # describe "#update"
end
