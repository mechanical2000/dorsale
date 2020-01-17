require "rails_helper"

RSpec.describe ::Dorsale::ExpenseGun::ExpensesController, type: :controller do
  routes { Dorsale::Engine.routes }
  let(:user) { create(:user) }
  before(:each) { sign_in(user) }

  describe "#index" do
    describe "filters" do
      render_views

      it "should filter by state" do
        expense1 = create(:expense_gun_expense, state: "accepted")
        expense2 = create(:expense_gun_expense, state: "refused")

        cookies[:filters] = {expense_state: "accepted"}.to_json
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
end
