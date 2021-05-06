require "rails_helper"

RSpec.describe ::Dorsale::ExpenseGun::ExpensesController, type: :controller do
  routes { Dorsale::Engine.routes }
  let(:user) { create(:user) }
  before(:each) { sign_in(user) }

  describe "#index" do
    describe "filters" do
      render_views

      it "should filter by state" do
        expense1 = create(:expense_gun_expense, state: "pending")
        expense2 = create(:expense_gun_expense, state: "canceled")

        cookies[:filters] = {expense_state: "pending"}.to_json
        get :index

        expect(assigns :expenses).to eq [expense1]
      end

      it "should filter by user" do
        user1    = create(:user)
        user2    = create(:user)
        expense1 = create(:expense_gun_expense, user: user1)
        expense2 = create(:expense_gun_expense, user: user2)

        cookies[:filters] = {expense_user_id: user1.id}.to_json
        get :index

        expect(assigns :expenses).to eq [expense1]
      end

      it "should assigns only users having expenses" do
        user1    = create(:user)
        user2    = create(:user)
        expense2 = create(:expense_gun_expense, user: user2)

        get :index

        expect(assigns :users).to eq [user2]
      end
    end # describe "filters"
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
