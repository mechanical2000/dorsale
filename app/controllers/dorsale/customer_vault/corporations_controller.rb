class Dorsale::CustomerVault::CorporationsController < ::Dorsale::CustomerVault::ApplicationController
  before_action :set_corporation, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  def show
    authorize @corporation, :read?
  end

  def new
    authorize model, :create?

    @corporation ||= scope.new

    @corporation.build_address if @corporation.address.nil?
  end

  def create
    authorize model, :create?

    @corporation ||= scope.new(corporation_params)

    if @corporation.save
      flash[:notice] = t("messages.corporations.create_ok")
      redirect_to back_url
    else
      render :new
    end
  end

  def edit
    authorize @corporation, :update?

    @corporation.build_address if @corporation.address.nil?
  end

  def update
    authorize @corporation, :update?

    if @corporation.update(corporation_params)
      flash[:notice] = t("messages.corporations.update_ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize @corporation, :delete?

    if @corporation.destroy
      flash[:notice] = t("messages.corporations.delete_ok")
    else
      flash[:alert] = t("messages.corporations.delete_error")
    end

    redirect_to customer_vault_people_path
  end

  private

  def model
    ::Dorsale::CustomerVault::Corporation
  end

  def scope
    policy_scope(model)
  end

  def back_url
    url_for(@corporation)
  end

  def set_corporation
    @corporation ||= scope.find(params[:id])
  end

  def permitted_params
    [
      :name,
      :short_name,
      :email,
      :www,
      :phone,
      :fax,
      :capital,
      :immatriculation_number_1,
      :immatriculation_number_2,
      :european_union_vat_number,
      :legal_form,
      :tag_list => [],
      :address_attributes => [
        :street,
        :street_bis,
        :zip,
        :city,
        :country
      ],
    ]
  end

  def corporation_params
    params.fetch(:corporation, {}).permit(permitted_params)
  end

end
