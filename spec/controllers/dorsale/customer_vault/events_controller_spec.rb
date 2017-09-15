require "rails_helper"

describe ::Dorsale::CustomerVault::EventsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe "#filters" do
    before do
      @event_1 = create(:customer_vault_event, action: "create")
      @event_2 = create(:customer_vault_event, action: "update")
    end

    it "should filter by event_action" do
      cookies[:filters] = {event_action: "create"}.to_json
      get :index
      expect(assigns(:events)).to eq [@event_1]
    end

    it "should filter by multiple event_action" do
      cookies[:filters] = {event_action: "create update"}.to_json
      get :index
      expect(assigns(:events)).to contain_exactly(@event_1, @event_2)
    end
  end # describe "#filters"

  describe "#index" do
    before do
      @corporation_1 = create(:customer_vault_corporation)
      @corporation_2 = create(:customer_vault_corporation)
      @event_1       = create(:customer_vault_event, person: @corporation_1, created_at: "2012-02-15")
      @event_2       = create(:customer_vault_event, person: @corporation_2, created_at: "2012-03-15")
    end

    it "should assigns all events ordered by created_at DESC" do
      get :index
      expect(assigns(:events)).to eq [@event_2, @event_1]
    end
  end # describe "#index"
end
