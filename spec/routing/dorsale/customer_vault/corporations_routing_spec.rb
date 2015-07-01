require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::CorporationsController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#new" do
      expect(get "/customer_vault/corporations/new").to \
      route_to("dorsale/customer_vault/corporations#new")
    end

    it "#show" do
      expect(get "/customer_vault/corporations/1").to \
      route_to("dorsale/customer_vault/corporations#show", id: "1")
    end

    it "#edit" do
      expect(get "/customer_vault/corporations/1/edit").to \
      route_to("dorsale/customer_vault/corporations#edit", id: "1")
    end

    it "#create" do
      expect(post "/customer_vault/corporations").to \
      route_to("dorsale/customer_vault/corporations#create")
    end

    it "#update" do
      expect(patch "/customer_vault/corporations/1").to \
      route_to("dorsale/customer_vault/corporations#update", id: "1")
    end

    it "#destroy" do
      expect(delete "/customer_vault/corporations/1").to \
      route_to("dorsale/customer_vault/corporations#destroy", id: "1")
    end

    describe 'links' do
      it "links#new" do
        expect(get "/customer_vault/corporations/1/links/new").to \
        route_to("dorsale/customer_vault/links#new", corporation_id: "1")
      end

      it "links#edit" do
        expect(get "/customer_vault/corporations/1/links/2/edit").to \
        route_to("dorsale/customer_vault/links#edit", corporation_id: "1", id: "2")
      end

      it "links#create" do
        expect(post "/customer_vault/corporations/1/links").to \
        route_to("dorsale/customer_vault/links#create", corporation_id: "1")
      end

      it "links#update" do
        expect(patch "/customer_vault/corporations/1/links/2").to \
        route_to("dorsale/customer_vault/links#update", corporation_id: "1", id: "2")
      end

      it "links#destroy" do
        expect(delete "/customer_vault/corporations/1/links/2").to \
        route_to("dorsale/customer_vault/links#destroy", corporation_id: "1", id: "2")
      end
    end

  end
end

