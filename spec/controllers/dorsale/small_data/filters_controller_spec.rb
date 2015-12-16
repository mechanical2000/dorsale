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

      it "should merge filters with previous filters" do
        action
        post :create, filters: {other_key: "value2"}
        expect(response.cookies["filters"]).to eq({key: "value", other_key: "value2"}.to_json)
      end
    end

    describe "back_url" do
      it "should reset page" do
        post :create, filters: {}, back_url: "/dorsale/flyboy/tasks"
        expect(response).to redirect_to "/dorsale/flyboy/tasks"

        post :create, filters: {}, back_url: "/dorsale/flyboy/tasks?&sort=term&page=3"
        expect(response).to redirect_to "/dorsale/flyboy/tasks?&sort=term"

        post :create, filters: {}, back_url: "/dorsale/flyboy/tasks?&sort=term&page=3&a=b"
        expect(response).to redirect_to "/dorsale/flyboy/tasks?&sort=term&a=b"

        post :create, filters: {}, back_url: "/dorsale/flyboy/tasks?page=3&a=b"
        expect(response).to redirect_to "/dorsale/flyboy/tasks?a=b"
      end
    end

  end
end
