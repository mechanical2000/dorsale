require "rails_helper"

RSpec.describe ::Dorsale::ExpenseGun::ExpensesController, type: :controller do
  routes { Dorsale::Engine.routes }
  let(:user) { create(:user) }
  before(:each) { sign_in(user) }

  describe "#index" do
    describe "filters" do
      render_views

      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:expense1) {
        create(:expense_gun_expense, state: "pending", user: user1, date: "2021-05-10")
      }
      let!(:expense2) {
        create(:expense_gun_expense, state: "canceled", user: user2, date: "2021-05-20")
      }

      def filter_by(**filters)
        cookies[:filters] = filters.to_json
        get :index
        assigns :expenses
      end

      it "should filter by state" do
        expect(filter_by expense_state: "pending").to eq [expense1]
      end

      it "should filter by user" do
        expect(filter_by expense_user_id: user1.id).to eq [expense1]
      end

      it "should filter by date period" do
        Timecop.freeze "2021-05-20"
        expect(filter_by expense_time_period: "this_week").to eq [expense2]
      end

      it "should filter by date begin" do
        expect(filter_by expense_date_begin: "2021-05-15").to eq [expense2]
      end

      it "should filter by date begin" do
        expect(filter_by expense_date_end: "2021-05-15").to eq [expense1]
      end

      it "should assigns only users having expenses" do
        expense1.destroy!
        get :index
        expect(assigns :users).to eq [user2]
      end
    end # describe "filters"

    it "should set total_payback" do
      create(:expense_gun_expense_line, total_all_taxes: 200, company_part: 50)
        .expense.update!(state: "pending")
      create(:expense_gun_expense_line, total_all_taxes: 50, company_part: 100)
        .expense.update!(state: "paid")
      get :index
      expect(assigns :total_payback).to eq 150
    end
  end # describe "#index"

  describe "#show" do
    render_views

    it "should be ok as PDF" do
      expense = create(:expense_gun_expense, user: user)
      get :show, params: {id: expense, format: :pdf}
      expect(response).to be_ok
    end
  end # describe "#show"

  describe "#go_to_pending" do
    it "should go to pending and redirect" do
      expense = create(:expense_gun_expense, user: user, state: "draft")
      post :go_to_pending, params: {id: expense}
      expect(response).to be_redirect
      expect(flash.notice).to be_present
      expect(expense.reload.state).to eq "pending"
    end
  end # describe "#go_to_pending"

  describe "#go_to_paid" do
    it "should go to paid and redirect" do
      expense = create(:expense_gun_expense, user: user, state: "pending")
      post :go_to_paid, params: {id: expense}
      expect(response).to be_redirect
      expect(flash.notice).to be_present
      expect(expense.reload.state).to eq "paid"
    end
  end # describe "#go_to_pending"

  describe "#go_to_canceled" do
    it "should go to canceled and redirect" do
      expense = create(:expense_gun_expense, user: user, state: "draft")
      post :go_to_canceled, params: {id: expense}
      expect(response).to be_redirect
      expect(flash.notice).to be_present
      expect(expense.reload.state).to eq "canceled"
    end
  end # describe "#go_to_pending"
end
