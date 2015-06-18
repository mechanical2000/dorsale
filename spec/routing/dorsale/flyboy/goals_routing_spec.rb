require "spec_helper"

describe ::Dorsale::Flyboy::GoalsController, type: :routing do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }

    it "routes to #index" do
      get("flyboy/goals").should route_to("dorsale/flyboy/goals#index")
    end

    it "routes to #new" do
      get("flyboy/goals/new").should route_to("dorsale/flyboy/goals#new")
    end

    it "routes to #show" do
      get("flyboy/goals/1").should route_to("dorsale/flyboy/goals#show", id: "1")
    end

    it "routes to #edit" do
      get("flyboy/goals/1/edit").should route_to("dorsale/flyboy/goals#edit", id: "1")
    end

    it "routes to #create" do
      post("flyboy/goals").should route_to("dorsale/flyboy/goals#create")
    end

    it "routes to #update" do
      patch("flyboy/goals/1").should route_to("dorsale/flyboy/goals#update", id: "1")
    end

    it "routes to #destroy" do
      delete("flyboy/goals/1").should route_to("dorsale/flyboy/goals#destroy", id: "1")
    end

    it "routes to #open" do
      patch("flyboy/goals/1/open").should route_to("dorsale/flyboy/goals#open", id: "1")
    end

    it "routes to #close" do
      patch("flyboy/goals/1/close").should route_to("dorsale/flyboy/goals#close", id: "1")
    end

  end
end
