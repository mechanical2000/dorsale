module Dorsale
  module ExpenseGun
    class ExpenseLinesController < ::Dorsale::ExpenseGun::ApplicationController
      before_action :set_objects

      def index
        redirect_to dorsale.expense_gun_expense_path(@expense)
      end

      def new
        authorize! :edit, @expense

        @expense_line = @expense.expense_lines.new
      end

      def create
        authorize! :edit, @expense

        @expense_line = @expense.expense_lines.new(expense_line_params)

        if @expense_line.save
          flash[:success] = t("expense_gun.expense_line.flash.created")
          redirect_to dorsale.expense_gun_expense_path(@expense)
        else
          render :new
        end
      end

      def edit
        authorize! :edit, @expense
      end

      def update
        authorize! :edit, @expense

        if @expense_line.update_attributes(expense_line_params)
          flash[:success] = t("expense_gun.expense_line.flash.created")
          redirect_to dorsale.expense_gun_expense_path(@expense)
        else
          render :edit
        end
      end

      def destroy
        authorize! :edit, @expense

        @expense_line.destroy
        flash[:success] = t("expense_gun.expense_line.flash.created")
        redirect_to dorsale.expense_gun_expense_path(@expense)
      end

      private

      def set_objects
        @expense      = Expense.find params[:expense_id]
        @expense_line = ExpenseLine.find params[:id] if params[:id].present?
      end

      def expense_line_params
        params.require(:expense_line).permit!
      end
    end
  end
end
