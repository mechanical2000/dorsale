require "rails_helper"

RSpec.describe Dorsale::CommentsController, type: :routing do
  routes { Dorsale::Engine.routes }

  describe "routing" do
    it "routes to #create" do
      expect(post: "/comments").to route_to("dorsale/comments#create")
    end

    it "routes to #edit" do
      expect(get: "/comments/3/edit").to route_to("dorsale/comments#edit", id: "3")
    end

    it "routes to #update" do
      expect(patch: "/comments/3").to route_to("dorsale/comments#update", id: "3")
    end

    it "routes to #destroy" do
      expect(delete: "/comments/3").to route_to("dorsale/comments#destroy", id: "3")
    end
  end
end
