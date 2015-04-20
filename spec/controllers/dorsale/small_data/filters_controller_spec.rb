require "rails_helper"

module Dorsale
  describe SmallData::FiltersController, type: :controller do
    routes { Dorsale::Engine.routes }

    let(:filters) { {key: "value"} }

    before(:each) do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    describe "create" do
      let(:action) {post :create, filters: filters}

      it "should redirect to refferer" do
        action
        expect(response).to redirect_to "where_i_came_from"
      end

      it "should redirect to call back url if defined" do
        post :create, filters: {key: "value"}, back_url: "xxx"
        expect(response).to redirect_to "xxx"
      end

      it "should store the filter in cookie" do
        action
        expect(response.cookies["filters"]).to eq(filters.to_json)
      end
    end
  end
end
