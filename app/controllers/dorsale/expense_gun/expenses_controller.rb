module Dorsale
  module ExpenseGun
    class ExpensesController < Dorsale::ExpenseGun::ApplicationController
      before_action :set_expense, only: [:show, :edit, :update, :destroy, :submit, :accept, :refuse, :cancel]

      def index
        authorize! :list, Expense

        if params[:state].blank?
          redirect_to state: "submited"
          return
        end

        if params[:state] == "all"
          @expenses ||= current_user.expenses
        else
          @expenses ||= current_user.expenses.where(state: params[:state])
        end

        @expenses = @expenses.page(params[:page])
        @all_expenses ||=  current_user.expenses
      end

      def new
        authorize! :create, Expense

        @expense ||= Expense.new
      end

      def create
        authorize! :create, Expense

        @expense = current_user.expenses.new(expense_params)

        if @expense.save
          flash[:success] = t("expense_gun.expense.flash.created")
          redirect_to dorsale.expense_gun_expense_path(@expense)
        else
          render :new
        end
      end

      def show
        authorize! :show, @expense
      end

      def edit
        authorize! :edit, @expense

        @expense_line ||= ExpenseGun::ExpenseLine.new
      end

      def update
        authorize! :edit, @expense

        if @expense.update_attributes(expense_params)
          flash[:success] = t("expense_gun.expense.flash.updated")
          redirect_to dorsale.expense_gun_expense_path(@expense)
        else
          render :edit
        end
      end

      def submit
        authorize! :submit, @expense

        @expense.submit!
        flash[:success] = t("expense_gun.expense.flash.submited")
        redirect_to dorsale.expense_gun_expenses_path
      end

      def accept
        authorize! :accept, @expense

        @expense.accept!
        flash[:success] = t("expense_gun.expense.flash.accepted")
        redirect_to dorsale.expense_gun_expense_path(@expense)
      end

      def refuse
        authorize! :refuse, @expense

        @expense.refuse!
        flash[:success] = t("expense_gun.expense.flash.refused")
        redirect_to dorsale.expense_gun_expenses_path
      end

      def cancel
        authorize! :cancel, @expense

        @expense.cancel!
        flash[:success] = t("expense_gun.expense.flash.canceled")
        redirect_to dorsale.expense_gun_expenses_path
      end

      private

      def set_expense
        @expense = Expense.find(params[:id])
      end

      def expense_params
        params.require(:expense_gun_expense).permit!
      end
    end
  end
end