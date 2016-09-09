class Dorsale::ExpenseGun::ExpensesController < Dorsale::ExpenseGun::ApplicationController
  before_action :set_expense, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :submit,
    :accept,
    :refuse,
    :cancel,
  ]

  def index
    authorize model, :list?

    if params[:state].blank?
      redirect_to state: "submited"
      return
    end

    @all_expenses ||= scope.all

    if params[:state] == "all"
      @expenses ||= @all_expenses
    else
      @expenses ||= @all_expenses.where(state: params[:state])
    end

    @expenses = @expenses.page(params[:page])
  end

  def new
    authorize model, :create?

    @expense ||= scope.new
  end

  def create
    authorize model, :create?

    @expense ||= scope.new(expense_params_for_create)

    if @expense.save
      flash[:success] = t("expense_gun.expense.flash.created")
      redirect_to dorsale.expense_gun_expense_path(@expense)
    else
      render :new
    end
  end

  def show
    authorize @expense, :read?
  end

  def edit
    authorize @expense, :update?

    @expense_line ||= ::Dorsale::ExpenseGun::ExpenseLine.new
  end

  def update
    authorize @expense, :update?

    if @expense.update(expense_params_for_update)
      flash[:success] = t("expense_gun.expense.flash.updated")
      redirect_to dorsale.expense_gun_expense_path(@expense)
    else
      render :edit
    end
  end

  def submit
    authorize @expense, :submit?

    @expense.submit!
    flash[:success] = t("expense_gun.expense.flash.submited")
    redirect_to dorsale.expense_gun_expenses_path
  end

  def accept
    authorize @expense, :accept?

    @expense.accept!
    flash[:success] = t("expense_gun.expense.flash.accepted")
    redirect_to dorsale.expense_gun_expense_path(@expense)
  end

  def refuse
    authorize @expense, :refuse?

    @expense.refuse!
    flash[:success] = t("expense_gun.expense.flash.refused")
    redirect_to dorsale.expense_gun_expenses_path
  end

  def cancel
    authorize @expense, :cancel?

    @expense.cancel!
    flash[:success] = t("expense_gun.expense.flash.canceled")
    redirect_to dorsale.expense_gun_expenses_path
  end

  private

  def model
    ::Dorsale::ExpenseGun::Expense
  end

  def scope
    policy_scope(model)
  end

  def set_expense
    @expense = scope.find(params[:id])
  end

  def expense_params
    params.fetch(:expense_gun_expense, {}).permit!
  end

  def expense_params_for_create
    expense_params.merge(user: current_user)
  end

  def expense_params_for_update
    expense_params
  end

end
