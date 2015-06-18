require "spec_helper"

describe ::Dorsale::Flyboy::GoalsController, type: :routing do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }

    it "routes to #index" do
      expect(get("flyboy/goals")).to route_to("dorsale/flyboy/goals#index")
    end

    it "routes to #new" do
      expect(get("flyboy/goals/new")).to route_to("dorsale/flyboy/goals#new")
    end

    it "routes to #show" do
      expect(get("flyboy/goals/1")).to route_to("dorsale/flyboy/goals#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("flyboy/goals/1/edit")).to route_to("dorsale/flyboy/goals#edit", id: "1")
    end

    it "routes to #create" do
      expect(post("flyboy/goals")).to route_to("dorsale/flyboy/goals#create")
    end

    it "routes to #update" do
      expect(patch("flyboy/goals/1")).to route_to("dorsale/flyboy/goals#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("flyboy/goals/1")).to route_to("dorsale/flyboy/goals#destroy", id: "1")
    end

    it "routes to #open" do
      expect(patch("flyboy/goals/1/open")).to route_to("dorsale/flyboy/goals#open", id: "1")
    end

    it "routes to #close" do
      expect(patch("flyboy/goals/1/close")).to route_to("dorsale/flyboy/goals#close", id: "1")
    end

  end
end
