require "rails_helper"

describe Dorsale::BillingMachine::QuotationsController, type: :controller do
  routes { Dorsale::Engine.routes }

  describe "#index" do
    it "stats should not include canceled quotations" do
      q1 = create(:billing_machine_quotation_line, quantity: 1, unit_price: 10)
      q1.quotation.update_attributes!(state: "pending")

      q2 = create(:billing_machine_quotation_line, quantity: 1, unit_price: 10)
      q2.quotation.update_attributes!(state: "canceled")

      get :index
      expect(assigns(:total_duty)).to eq 10
    end

    it "stats should be 0 if no quotations" do
      get :index
      expect(assigns(:total_duty)).to eq 0
      expect(assigns(:vat_amount)).to eq 0
      expect(assigns(:total_all_taxes)).to eq 0
    end
  end
end
