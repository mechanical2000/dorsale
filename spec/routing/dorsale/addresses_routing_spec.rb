require "rails_helper"

module Dorsale
  RSpec.describe AddressesController, :type => :routing do
    routes { Dorsale::Engine.routes }
    describe "routing" do

      it "routes to #index" do
        expect(:get => "/addresses").to route_to("dorsale/addresses#index")
      end

      it "routes to #new" do
        expect(:get => "/addresses/new").to route_to("dorsale/addresses#new")
      end

      it "routes to #show" do
        expect(:get => "/addresses/1").to route_to("dorsale/addresses#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/addresses/1/edit").to route_to("dorsale/addresses#edit", :id => "1")
      end

      it "routes to #create" do
        expect(:post => "/addresses").to route_to("dorsale/addresses#create")
      end

      it "routes to #update" do
        expect(:put => "/addresses/1").to route_to("dorsale/addresses#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/addresses/1").to route_to("dorsale/addresses#destroy", :id => "1")
      end

    end
  end
end
