require "rails_helper"

describe Dorsale::BillingMachine::QuotationsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }
  before(:each) { sign_in(user) }

  describe "#preview" do
    render_views

    it "should render show" do
      post :preview
      expect(response).to render_template(:show)
    end

    it "should not save" do
      post :preview
      @quotation = assigns(:quotation)
      expect(@quotation).to be_valid
      expect(@quotation).to_not be_persisted
    end
  end # describe "#preview" do
end
