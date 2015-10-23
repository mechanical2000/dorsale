require "rails_helper"

describe ::Dorsale::BillingMachine::QuotationsController do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }

    it "#index" do
      expect(get "/billing_machine/quotations").to \
      route_to("dorsale/billing_machine/quotations#index")
    end

    it "#new" do
      expect(get "/billing_machine/quotations/new").to \
      route_to("dorsale/billing_machine/quotations#new")
    end

    it "#show" do
      expect(get "/billing_machine/quotations/1").to \
      route_to("dorsale/billing_machine/quotations#show", id: "1")
    end

    it "#edit" do
      expect(get "/billing_machine/quotations/1/edit").to \
      route_to("dorsale/billing_machine/quotations#edit", id: "1")
    end

    it "#create" do
      expect(post "/billing_machine/quotations").to \
      route_to("dorsale/billing_machine/quotations#create")
    end

    it "#update" do
      expect(patch "/billing_machine/quotations/1").to \
      route_to("dorsale/billing_machine/quotations#update", id: "1")
    end

    it "#destroy" do
      expect(delete "/billing_machine/quotations/1").to \
      route_to("dorsale/billing_machine/quotations#destroy", id: "1")
    end

    it "#copy" do
      expect(post "/billing_machine/quotations/1/copy").to \
      route_to("dorsale/billing_machine/quotations#copy", id: "1")
    end

  end
end
