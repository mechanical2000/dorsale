require "rails_helper"

RSpec.describe ::Dorsale::UsersController, type: :routing do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }
    it "routes to #index" do
      expect(:get => "users").to route_to("dorsale/users#index")
    end

    it "routes to #new" do
      expect(:get => "users/new").to route_to("dorsale/users#new")
    end

    it "route to #show" do
      expect(:get => "users/1").to route_to("dorsale/users#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "users/1/edit").to route_to("dorsale/users#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "users").to route_to("dorsale/users#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "users/1").to route_to("dorsale/users#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "users/1").to route_to("dorsale/users#update", :id => "1")
    end

    it "doesn't route to #destroy" do
      expect(:delete => "users/1").not_to be_routable
    end
  end
end
