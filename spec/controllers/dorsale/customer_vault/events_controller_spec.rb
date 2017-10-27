require "rails_helper"

describe ::Dorsale::CustomerVault::EventsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe "#filters" do
    before do
      @event1 = create(:customer_vault_event, action: "create")
      @event2 = create(:customer_vault_event, action: "update")
    end

    it "should filter by event_action" do
      cookies[:filters] = {event_action: "create"}.to_json
      get :index
      expect(assigns(:events)).to eq [@event1]
    end

    it "should filter by multiple event_action" do
      cookies[:filters] = {event_action: "create update"}.to_json
      get :index
      expect(assigns(:events)).to contain_exactly(@event1, @event2)
    end
  end # describe "#filters"

  describe "#index" do
    before do
      @corporation1 = create(:customer_vault_corporation)
      @corporation2 = create(:customer_vault_corporation)
      @event1       = create(:customer_vault_event, person: @corporation1, created_at: "2012-02-15")
      @event2       = create(:customer_vault_event, person: @corporation2, created_at: "2012-03-15")
    end

    it "should assigns all events ordered by created_at DESC" do
      get :index
      expect(assigns(:events)).to eq [@event2, @event1]
    end
  end # describe "#index"
end
