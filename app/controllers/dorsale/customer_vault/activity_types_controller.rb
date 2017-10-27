class Dorsale::CustomerVault::ActivityTypesController < ::Dorsale::CustomerVault::ApplicationController
  before_action :set_objects, only: [:edit, :update]

  def index
    authorize model, :list?

    @activity_types ||= scope.all
  end

  def new
    @activity_type ||= scope.new

    authorize @activity_type, :create?
  end

  def create
    @activity_type ||= scope.new(activity_type_params_for_create)

    authorize @activity_type, :create?

    if @activity_type.save
      flash[:notice] = t("messages.activity_types.create_ok")
      redirect_to back_url
    else
      render action: :new
    end
  end

  def edit
    authorize @activity_type, :update?
  end

  def update
    authorize @activity_type, :update?

    if @activity_type.update(activity_type_params_for_update)
      flash[:notice] = t("messages.activity_types.update_ok")
      redirect_to back_url
    else
      render action: :edit
    end
  end

  private

  def set_objects
    @activity_type ||= scope.find(params[:id])
  end

  def model
    ::Dorsale::CustomerVault::ActivityType
  end

  def back_url
    customer_vault_activity_types_path
  end

  def permitted_params
    [
      :name,
    ]
  end

  def activity_type_params
    params.fetch(:activity_type, {}).permit(permitted_params)
  end

  def activity_type_params_for_create
    activity_type_params
  end

  def activity_type_params_for_update
    activity_type_params
  end
end
