require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::EventsController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get "/customer_vault/events").to \
      route_to("dorsale/customer_vault/events#index")
    end
  end # describe "routing"
end
