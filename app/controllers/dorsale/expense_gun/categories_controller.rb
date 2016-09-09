class Dorsale::ExpenseGun::CategoriesController < ::Dorsale::ExpenseGun::ApplicationController
  def index
    authorize model, :list?

    @categories ||= model.all
  end

  def new
    @category = model.new

    authorize @category, :create?
  end

  def create
    @category ||= model.new(category_params)

    authorize @category, :create?

    if @category.save
      flash[:notice] = t("categories.create_ok")
      redirect_to back_url
    else
      render action: "new"
    end
  end

  def edit
    @category = model.find(params[:id])
    authorize @category, :update?
  end

  def update
    @category ||= model.find(params[:id])

    authorize @category, :update?

    if @category.update_attributes(category_params)
      flash[:notice] = t("categories.update_ok")
      redirect_to back_url
    else
      render action: "edit"
    end
  end

  private

  def model
    ::Dorsale::ExpenseGun::Category
  end

  def back_url
    expense_gun_categories_path
  end

  def permitted_params
    [
      :name,
      :code,
      :vat_deductible,
    ]
  end

  def category_params
    params.fetch(:expense_gun_category, {}).permit(permitted_params)
  end

end
