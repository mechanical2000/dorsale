require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::CorporationsController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#new" do
      expect(get "/customer_vault/individuals/new").to \
      route_to("dorsale/customer_vault/individuals#new")
    end

    it "#show" do
      expect(get "/customer_vault/individuals/1").to \
      route_to("dorsale/customer_vault/individuals#show", id: "1")
    end

    it "#edit" do
      expect(get "/customer_vault/individuals/1/edit").to \
      route_to("dorsale/customer_vault/individuals#edit", id: "1")
    end

    it "#create" do
      expect(post "/customer_vault/individuals").to \
      route_to("dorsale/customer_vault/individuals#create")
    end

    it "#update" do
      expect(patch "/customer_vault/individuals/1").to \
      route_to("dorsale/customer_vault/individuals#update", id: "1")
    end

    it "#destroy" do
      expect(delete "/customer_vault/individuals/1").to \
      route_to("dorsale/customer_vault/individuals#destroy", id: "1")
    end

    describe 'links' do
      it "links#new" do
        expect(get "/customer_vault/individuals/1/links/new").to \
        route_to("dorsale/customer_vault/links#new", individual_id: "1")
      end

      it "links#edit" do
        expect(get "/customer_vault/individuals/1/links/2/edit").to \
        route_to("dorsale/customer_vault/links#edit", individual_id: "1", id: "2")
      end

      it "links#create" do
        expect(post "/customer_vault/individuals/1/links").to \
        route_to("dorsale/customer_vault/links#create", individual_id: "1")
      end

      it "links#update" do
        expect(patch "/customer_vault/individuals/1/links/2").to \
        route_to("dorsale/customer_vault/links#update", individual_id: "1", id: "2")
      end

      it "links#destroy" do
        expect(delete "/customer_vault/individuals/1/links/2").to \
        route_to("dorsale/customer_vault/links#destroy", individual_id: "1", id: "2")
      end
    end

  end
end

