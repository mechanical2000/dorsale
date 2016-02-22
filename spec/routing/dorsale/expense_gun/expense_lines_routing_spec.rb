require "rails_helper"

describe ::Dorsale::ExpenseGun::ExpenseLinesController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get('/expense_gun/expenses/1/expense_lines'))
      .to route_to(controller: 'dorsale/expense_gun/expense_lines', expense_id: '1', action: 'index')
    end

    it "#new" do
      expect(get('/expense_gun/expenses/1/expense_lines/new'))
      .to route_to(controller: 'dorsale/expense_gun/expense_lines', expense_id: '1',action: 'new')
    end

    it "#create" do
      expect(post('/expense_gun/expenses/1/expense_lines'))
      .to route_to(controller: 'dorsale/expense_gun/expense_lines', expense_id: '1',action: 'create')
    end

    it "#show" do
      expect(get('/expense_gun/expenses/1/expense_lines/1'))
      .to route_to(controller: 'dorsale/expense_gun/expense_lines', expense_id: '1', id: '1',action: 'show')
    end

    it "#edit" do
      expect(get('/expense_gun/expenses/1/expense_lines/1/edit'))
      .to route_to(controller: 'dorsale/expense_gun/expense_lines', expense_id: '1', id: '1',action: 'edit')
    end

    it "#update via patch" do
      expect(patch('/expense_gun/expenses/1/expense_lines/1'))
      .to route_to(controller: 'dorsale/expense_gun/expense_lines', expense_id: '1', id: '1',action: 'update')
    end

    it "#update via put" do
      expect(put('/expense_gun/expenses/1/expense_lines/1'))
      .to route_to(controller: 'dorsale/expense_gun/expense_lines', expense_id: '1', id: '1',action: 'update')
    end

    it "#destroy" do
      expect(delete('/expense_gun/expenses/1/expense_lines/1'))
      .to route_to(controller: 'dorsale/expense_gun/expense_lines', expense_id: '1', id: '1',action: 'destroy')
    end

  end
end
