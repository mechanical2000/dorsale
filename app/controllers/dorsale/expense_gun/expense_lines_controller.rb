class Dorsale::ExpenseGun::ExpenseLinesController < ::Dorsale::ExpenseGun::ApplicationController
  before_action :set_objects

  def index
    redirect_to back_url
  end

  def new
    authorize @expense, :update?

    @expense_line = @expense.expense_lines.new
  end

  def create
    authorize @expense, :update?

    @expense_line = @expense.expense_lines.new(expense_line_params)

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

    if @expense_line.update_attributes(expense_line_params)
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
    @expense      = ::Dorsale::ExpenseGun::Expense.find params[:expense_id]
    @expense_line = ::Dorsale::ExpenseGun::ExpenseLine.find params[:id] if params[:id].present?
  end

  def expense_line_params
    params.fetch(:expense_line, {}).permit!
  end

end
