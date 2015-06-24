require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::PeopleController, type: :routing do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }

    it "#index" do
      expect(get "/customer_vault/people").to \
      route_to("dorsale/customer_vault/people#index")
    end

    it "#list" do
      expect(get "/customer_vault/people/list").to \
      route_to("dorsale/customer_vault/people#list")
    end

    it "#activity" do
      expect(get "/customer_vault/people/activity").to \
      route_to("dorsale/customer_vault/people#activity")
    end
  end
end
