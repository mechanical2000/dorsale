require "rails_helper"

RSpec.describe Dorsale::Alexandrie::AttachmentsController, type: :routing do
  routes { Dorsale::Engine.routes }

  describe "routing" do

    it "#create" do
      expect(post "/alexandrie/attachments").to \
      route_to("dorsale/alexandrie/attachments#create")
    end

    it "#destroy" do
      expect(delete "/alexandrie/attachments/3").to \
      route_to("dorsale/alexandrie/attachments#destroy", id: "3")
    end

  end
end
