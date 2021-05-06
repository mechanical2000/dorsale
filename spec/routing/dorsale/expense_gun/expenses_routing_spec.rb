require "rails_helper"

describe ::Dorsale::ExpenseGun::ExpensesController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get "/expense_gun/expenses").to \
        route_to("dorsale/expense_gun/expenses#index")
    end

    it "#new" do
      expect(get "/expense_gun/expenses/new").to \
        route_to("dorsale/expense_gun/expenses#new")
    end

    it "#create" do
      expect(post "/expense_gun/expenses").to \
        route_to("dorsale/expense_gun/expenses#create")
    end

    it "#show" do
      expect(get "/expense_gun/expenses/1").to \
        route_to("dorsale/expense_gun/expenses#show", id: "1")
    end

    it "#edit" do
      expect(get "/expense_gun/expenses/1/edit").to \
        route_to("dorsale/expense_gun/expenses#edit", id: "1")
    end

    it "#update" do
      expect(patch "/expense_gun/expenses/1").to \
        route_to("dorsale/expense_gun/expenses#update", id: "1")
    end

    it "#go_to_pending" do
      expect(post "/expense_gun/expenses/1/go_to_pending").to \
        route_to("dorsale/expense_gun/expenses#go_to_pending", id: "1")
    end

    it "#go_to_paid" do
      expect(post "/expense_gun/expenses/1/go_to_paid").to \
        route_to("dorsale/expense_gun/expenses#go_to_paid", id: "1")
    end

    it "#go_to_canceled" do
      expect(post "/expense_gun/expenses/1/go_to_canceled").to \
        route_to("dorsale/expense_gun/expenses#go_to_canceled", id: "1")
    end

    it "#copy" do
      expect(get "/expense_gun/expenses/1/copy").to \
        route_to("dorsale/expense_gun/expenses#copy", id: "1")
    end
  end
end
