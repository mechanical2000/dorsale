class Dorsale::CustomerVault::OriginsController < ::Dorsale::CustomerVault::ApplicationController
  before_action :set_objects, only: [:edit, :update]

  def index
    authorize model, :list?

    @origins ||= scope.all
  end

  def new
    @origin ||= scope.new

    authorize @origin, :create?
  end

  def create
    @origin ||= scope.new(origin_params_for_create)

    authorize @origin, :create?

    if @origin.save
      flash[:notice] = t("messages.origins.create_ok")
      redirect_to back_url
    else
      render action: :new
    end
  end

  def edit
    authorize @origin, :update?
  end

  def update
    authorize @origin, :update?

    if @origin.update(origin_params_for_update)
      flash[:notice] = t("messages.origins.update_ok")
      redirect_to back_url
    else
      render action: :edit
    end
  end

  private

  def set_objects
    @origin ||= scope.find(params[:id])
  end

  def model
    ::Dorsale::CustomerVault::Origin
  end

  def back_url
    customer_vault_origins_path
  end

  def permitted_params
    [
      :name,
    ]
  end

  def origin_params
    params.fetch(:origin, {}).permit(permitted_params)
  end

  def origin_params_for_create
    origin_params
  end

  def origin_params_for_update
    origin_params
  end

end
