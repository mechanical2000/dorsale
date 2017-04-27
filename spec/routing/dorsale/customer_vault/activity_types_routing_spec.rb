require "rails_helper"

describe ::Dorsale::CustomerVault::ActivityTypesController do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get "/customer_vault/activity_types").to \
      route_to("dorsale/customer_vault/activity_types#index")
    end

    it "#new" do
      expect(get "/customer_vault/activity_types/new").to \
      route_to("dorsale/customer_vault/activity_types#new")
    end

    it "#create" do
      expect(post "/customer_vault/activity_types").to \
      route_to("dorsale/customer_vault/activity_types#create")
    end

    it "#show" do
      expect(get "/customer_vault/activity_types/3").to_not be_routable
    end

    it "#edit" do
      expect(get "/customer_vault/activity_types/3/edit").to \
      route_to("dorsale/customer_vault/activity_types#edit", id: "3")
    end

    it "#update" do
      expect(patch "/customer_vault/activity_types/3").to \
      route_to("dorsale/customer_vault/activity_types#update", id: "3")
    end

    it "#destroy" do
      expect(delete "/customer_vault/activity_types/3").to_not be_routable
    end
  end
end
