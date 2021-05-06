class Dorsale::ExpenseGun::ExpensesController < Dorsale::ExpenseGun::ApplicationController
  before_action :set_expense
  before_action :set_filters_variables, only: [:index]

  def index
    authorize model, :list?

    @expenses ||= scope.all.preload(:user, :expense_lines)
    @filters ||= Dorsale::ExpenseGun::SmallData::FilterForExpenses.new(filters_jar)
    @expenses = @filters.apply(@expenses)
    @expenses = Dorsale::ExpenseGun::ExpensesSorter.call(@expenses, params[:sort] ||= "-created_at")
    @expenses = @expenses.page(params[:page]).per(25)

    @total_payback = @expenses.limit(nil).to_a.sum(&:total_employee_payback)
  end

  def new
    authorize model, :create?

    @expense ||= scope.new
    @expense.expense_lines.build if @expense.expense_lines.empty?
  end

  def create
    authorize model, :create?

    @expense ||= scope.new(expense_params_for_create)

    if @expense.save
      set_succress_flash
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

    @expense.expense_lines.build if @expense.expense_lines.empty?
  end

  def update
    authorize @expense, :update?

    if @expense.update(expense_params_for_update)
      set_succress_flash
      redirect_to dorsale.expense_gun_expense_path(@expense)
    else
      render :edit
    end
  end

  def copy
    authorize @expense, :copy?

    @original = @expense
    @expense  = ::Dorsale::ExpenseGun::Expense::Copy.(@original)

    render :new
  end

  def go_to_pending
    authorize @expense, :go_to_pending?

    @expense.update!(state: "pending")
    set_succress_flash
    redirect_to dorsale.expense_gun_expenses_path
  end

  def go_to_paid
    authorize @expense, :go_to_paid?

    @expense.update!(state: "paid")
    set_succress_flash
    redirect_to dorsale.expense_gun_expenses_path
  end

  def go_to_canceled
    authorize @expense, :go_to_canceled?

    @expense.update!(state: "canceled")
    set_succress_flash
    redirect_to dorsale.expense_gun_expenses_path
  end

  private

  def set_succress_flash
    flash.notice = t("expense_gun.expense.messages.#{action_name}_ok")
  end

  def model
    ::Dorsale::ExpenseGun::Expense
  end

  def set_expense
    @expense = scope.find(params[:id]) if params.key?(:id)
  end

  def permitted_params
    [
      :state,
      :name,
      :date,
      :expense_lines_attributes => [
        :id,
        :_destroy,
        :name,
        :date,
        :category_id,
        :total_all_taxes,
        :vat,
        :company_part,
      ],
    ]
  end

  def expense_params
    params.fetch(:expense, {}).permit(permitted_params)
  end

  def expense_params_for_create
    expense_params.merge(user: current_user)
  end

  def expense_params_for_update
    expense_params
  end

  def set_filters_variables
    @users ||= scope.preload(:user).map(&:user).uniq.compact
  end
end
