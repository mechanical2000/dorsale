require "rails_helper"

describe Dorsale::BillingMachine::InvoicesController, type: :controller do
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
      @invoice = assigns(:invoice)
      expect(@invoice).to be_valid
      expect(@invoice).to_not be_persisted
    end
  end # describe "#preview" do

  describe "XLSX export" do
    render_views

    it "should be ok" do
      3.times { create(:billing_machine_invoice_line) }
      get :index, params: {format: :xlsx}
      expect(response).to be_ok
    end
  end # describe "XLSX export"

  describe "PDF export" do
    render_views

    it "should be ok" do
      3.times {
        invoice = create(:billing_machine_invoice)
        Dorsale::BillingMachine::PdfFileGenerator.(invoice)
      }
      get :index, params: {format: :pdf}
      expect(response).to be_ok
    end
  end # describe "PDF export"

  describe "filters" do
    describe "filter by date" do
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
        expect(assigns :invoices).to contain_exactly(@today)
      end

      it "should filter by yesterday" do
        filter :yesterday
        expect(assigns :invoices).to contain_exactly(@yesterday)
      end

      it "should filter by this_week" do
        filter :this_week
        expect(assigns :invoices).to contain_exactly(@today, @yesterday, @tomorrow)
      end

      it "should filter by this_month" do
        filter :this_month
        expect(assigns :invoices).to contain_exactly(@today, @yesterday, @tomorrow, @last_week)
      end

      it "should filter by this_year" do
        filter :this_year
        expect(assigns :invoices).to \
          contain_exactly(@today, @yesterday, @tomorrow, @last_week, @last_month)
      end

      it "should filter by last_week" do
        filter :last_week
        expect(assigns :invoices).to contain_exactly(@last_week)
      end

      it "should filter by last_month" do
        filter :last_month
        expect(assigns :invoices).to contain_exactly(@last_month)
      end

      it "should filter by last_year" do
        filter :last_year
        expect(assigns :invoices).to contain_exactly(@last_year)
      end
    end # describe "filter by date"

    describe "filter by payment status" do
      before do
        Timecop.freeze "2016-11-08 12:00:00"
        @paid       = create(:billing_machine_invoice, paid: true,  due_date: "2016-01-08")
        @pending    = create(:billing_machine_invoice, paid: false, due_date: "2016-11-10")
        @late       = create(:billing_machine_invoice, paid: false, due_date: "2016-06-05")
      end

      def filter(value)
        cookies[:filters] = {"bm_payment_status" => value.to_s}.to_json
        get :index
      end

      it "should filter by paid" do
        filter :paid
        expect(assigns :invoices).to contain_exactly(@paid)
      end

      it "should filter by unpaid" do
        filter :unpaid
        expect(assigns :invoices).to contain_exactly(@pending, @late)
      end

      it "should filter by pending" do
        filter :pending
        expect(assigns :invoices).to contain_exactly(@pending)
      end

      it "should filter by late" do
        filter :late
        expect(assigns :invoices).to contain_exactly(@late)
      end
    end # describe "filter by payment status"
  end # describe "filters"
end
