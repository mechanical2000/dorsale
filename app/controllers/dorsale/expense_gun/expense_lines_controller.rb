class Dorsale::ExpenseGun::ExpenseLinesController < ::Dorsale::ExpenseGun::ApplicationController
  before_action :set_objects

  def index
    redirect_to back_url
  end

  def new
    authorize @expense, :update?

    @expense_line ||= @expense.expense_lines.new
  end

  def create
    authorize @expense, :update?

    @expense_line ||= @expense.expense_lines.new(expense_line_params_for_create)

    if @expense_line.save
      flash[:success] = t("expense_gun.expense_line.flash.created")
      redirect_to back_url
    else
      render :new
    end
  end

  def edit
    authorize @expense, :update?
  end

  def update
    authorize @expense, :update?

    if @expense_line.update(expense_line_params_for_update)
      flash[:success] = t("expense_gun.expense_line.flash.created")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize @expense, :update?

    @expense_line.destroy
    flash[:success] = t("expense_gun.expense_line.flash.created")
    redirect_to back_url
  end

  private

  def back_url
    dorsale.expense_gun_expense_path(@expense)
  end

  def set_objects
    @expense      ||= policy_scope(::Dorsale::ExpenseGun::Expense).find(params[:expense_id])
    @expense_line ||= @expense.expense_lines.find params[:id] if params[:id].present?
  end

  def expense_line_params
    params.fetch(:expense_line, {}).permit!
  end

  def expense_line_params_for_create
    expense_line_params
  end

  def expense_line_params_for_update
    expense_line_params
  end

end
