require "rails_helper"

describe ::Dorsale::BillingMachine::InvoicesController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get "/billing_machine/invoices").to \
        route_to("dorsale/billing_machine/invoices#index")
    end

    it "#new" do
      expect(get "/billing_machine/invoices/new").to \
        route_to("dorsale/billing_machine/invoices#new")
    end

    it "#create" do
      expect(post "/billing_machine/invoices").to \
        route_to("dorsale/billing_machine/invoices#create")
    end

    it "#show" do
      expect(get "/billing_machine/invoices/1").to \
        route_to("dorsale/billing_machine/invoices#show", id: "1")
    end

    it "#show pdf" do
      expect(get "/billing_machine/invoices/1.pdf").to \
        route_to("dorsale/billing_machine/invoices#show", id: "1", format: "pdf")
    end

    it "#pay" do
      expect(patch "/billing_machine/invoices/1/pay").to \
        route_to("dorsale/billing_machine/invoices#pay", id: "1")
    end

    it "#copy" do
      expect(get "/billing_machine/invoices/1/copy").to \
        route_to("dorsale/billing_machine/invoices#copy", id: "1")
    end

    it "#edit" do
      expect(get "/billing_machine/invoices/1/edit").to \
        route_to("dorsale/billing_machine/invoices#edit", id: "1")
    end

    it "#update" do
      expect(patch "/billing_machine/invoices/1").to \
        route_to("dorsale/billing_machine/invoices#update", id: "1")
    end

    it "#preview" do
      expect(post "/billing_machine/invoices/preview").to \
        route_to("dorsale/billing_machine/invoices#preview")
    end

    it "#email via GET" do
      expect(get "/billing_machine/invoices/1/email").to \
        route_to("dorsale/billing_machine/invoices#email", id: "1")
    end

    it "#email via PORT" do
      expect(post "/billing_machine/invoices/1/email").to \
        route_to("dorsale/billing_machine/invoices#email", id: "1")
    end
  end
end
