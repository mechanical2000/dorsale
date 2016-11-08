require "rails_helper"

describe Dorsale::BillingMachine::InvoicesController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }
  before(:each) { sign_in(user) }

  describe "CSV export" do
    render_views

    it "should be ok" do
      3.times { create(:billing_machine_invoice_line) }
      get :index, params: {format: :csv}
      expect(response).to be_ok
      expect(response.body.split("\n").length).to eq 4 # headers + 3 invoices
    end
  end # describe "CSV export"

  describe "filters" do
    before do
      Timecop.freeze "2016-11-08 12:00:00"
      @today      = create(:billing_machine_invoice, date: "2016-11-08")
      @yesterday  = create(:billing_machine_invoice, date: "2016-11-07")
      @tomorrow   = create(:billing_machine_invoice, date: "2016-11-09")
      @last_week  = create(:billing_machine_invoice, date: "2016-11-04")
      @last_month = create(:billing_machine_invoice, date: "2016-10-18")
      @last_year  = create(:billing_machine_invoice, date: "2015-10-18")
    end

    def filter(period)
      cookies[:filters] = {"bm_time_period" => period.to_s}.to_json
      get :index
    end

    it "should filter by all_time" do
      filter :all_time
      expect(assigns :invoices).to contain_exactly(
        @today,
        @yesterday,
        @tomorrow,
        @last_week,
        @last_month,
        @last_year,
      )
    end

    it "should filter by today" do
      filter :today
      expect(assigns :invoices).to contain_exactly(
        @today,
      )
    end

    it "should filter by yesterday" do
      filter :yesterday
      expect(assigns :invoices).to contain_exactly(
        @yesterday,
      )
    end

    it "should filter by this_week" do
      filter :this_week
      expect(assigns :invoices).to contain_exactly(
        @today,
        @yesterday,
        @tomorrow,
      )
    end

    it "should filter by this_month" do
      filter :this_month
      expect(assigns :invoices).to contain_exactly(
        @today,
        @yesterday,
        @tomorrow,
        @last_week,
      )
    end

    it "should filter by this_year" do
      filter :this_year
      expect(assigns :invoices).to contain_exactly(
        @today,
        @yesterday,
        @tomorrow,
        @last_week,
        @last_month,
      )
    end

    it "should filter by last_week" do
      filter :last_week
      expect(assigns :invoices).to contain_exactly(
        @last_week,
      )
    end

    it "should filter by last_month" do
      filter :last_month
      expect(assigns :invoices).to contain_exactly(
        @last_month,
      )
    end

    it "should filter by last_year" do
      filter :last_year
      expect(assigns :invoices).to contain_exactly(
        @last_year,
      )
    end
  end # describe "filters"

end
