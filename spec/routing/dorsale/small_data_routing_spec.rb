require "rails_helper"

module Dorsale
  RSpec.describe SmallData::FiltersController, :type => :routing do
    routes { Dorsale::Engine.routes }

    describe "routing" do

      it "routes to #create" do
        expect(post: "/small_data/filters").to route_to("dorsale/small_data/filters#create")
      end

    end
  end
end
