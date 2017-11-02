require "rails_helper"

describe ::Dorsale::CustomerVault::OriginsController do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get "/customer_vault/origins").to \
        route_to("dorsale/customer_vault/origins#index")
    end

    it "#new" do
      expect(get "/customer_vault/origins/new").to \
        route_to("dorsale/customer_vault/origins#new")
    end

    it "#create" do
      expect(post "/customer_vault/origins").to \
        route_to("dorsale/customer_vault/origins#create")
    end

    it "#show" do
      expect(get "/customer_vault/origins/3").to_not be_routable
    end

    it "#edit" do
      expect(get "/customer_vault/origins/3/edit").to \
        route_to("dorsale/customer_vault/origins#edit", id: "3")
    end

    it "#update" do
      expect(patch "/customer_vault/origins/3").to \
        route_to("dorsale/customer_vault/origins#update", id: "3")
    end

    it "#destroy" do
      expect(delete "/customer_vault/origins/3").to_not be_routable
    end
  end
end
