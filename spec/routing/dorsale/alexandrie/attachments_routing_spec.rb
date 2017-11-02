require "rails_helper"

RSpec.describe Dorsale::Alexandrie::AttachmentsController, type: :routing do
  routes { Dorsale::Engine.routes }

  describe "routing" do
    it "#create" do
      expect(get "/alexandrie/attachments").to \
        route_to("dorsale/alexandrie/attachments#index")
    end

    it "#create" do
      expect(post "/alexandrie/attachments").to \
        route_to("dorsale/alexandrie/attachments#create")
    end

    it "#edit" do
      expect(get "/alexandrie/attachments/3/edit").to \
        route_to("dorsale/alexandrie/attachments#edit", id: "3")
    end

    it "#update" do
      expect(patch "/alexandrie/attachments/3").to \
        route_to("dorsale/alexandrie/attachments#update", id: "3")
    end

    it "#destroy" do
      expect(delete "/alexandrie/attachments/3").to \
        route_to("dorsale/alexandrie/attachments#destroy", id: "3")
    end
  end
end
