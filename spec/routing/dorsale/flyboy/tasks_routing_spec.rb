require "spec_helper"

describe ::Dorsale::Flyboy::TasksController, type: :routing do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }

    it "routes to #index" do
      get("flyboy/tasks").should route_to("dorsale/flyboy/tasks#index")
    end

    it "routes to #new" do
      get("flyboy/tasks/new").should route_to("dorsale/flyboy/tasks#new")
    end

    it "routes to #show" do
      get("flyboy/tasks/1").should route_to("dorsale/flyboy/tasks#show", id: "1")
    end

    it "routes to #edit" do
      get("flyboy/tasks/1/edit").should route_to("dorsale/flyboy/tasks#edit", id: "1")
    end

    it "routes to #create" do
      post("flyboy/tasks").should route_to("dorsale/flyboy/tasks#create")
    end

    it "routes to #update" do
      patch("flyboy/tasks/1").should route_to("dorsale/flyboy/tasks#update", id: "1")
    end

    it "routes to #complete" do
      patch("flyboy/tasks/1/complete").should route_to("dorsale/flyboy/tasks#complete", id: "1")
    end

    it "routes to #snooze" do
      patch("flyboy/tasks/1/snooze").should route_to("dorsale/flyboy/tasks#snooze", id: "1")
    end

    it "routes to #destroy" do
      delete("flyboy/tasks/1").should route_to("dorsale/flyboy/tasks#destroy", id: "1")
    end

  end
end
