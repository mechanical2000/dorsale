class Dorsale::CustomerVault::CorporationsController < ::Dorsale::CustomerVault::ApplicationController
  before_action :set_corporation, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  def show
    authorize! :read, @corporation
  end

  def new
    authorize! :create, model

    @corporation ||= current_user_scope.new_corporation

    @corporation.build_address if @corporation.address.nil?
  end

  def create
    authorize! :create, model

    @corporation ||= current_user_scope.new_corporation(corporation_params)

    if @corporation.save
      flash[:notice] = t("messages.corporations.create_ok")
      redirect_to back_url
    else
      render :new
    end
  end

  def edit
    authorize! :update, @corporation

    @corporation.build_address if @corporation.address.nil?
  end

  def update
    authorize! :update, @corporation

    if @corporation.update(corporation_params)
      flash[:notice] = t("messages.corporations.update_ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize! :delete, @corporation

    if @corporation.destroy
      flash[:notice] = t("messages.corporations.destroy_ok")
    else
      flash[:alert] = t("messages.corporations.destroy_error")
    end

    redirect_to customer_vault_people_path
  end

  private

  def model
    ::Dorsale::CustomerVault::Corporation
  end

  def back_url
    url_for(@corporation)
  end

  def set_corporation
    @corporation = model.find(params[:id])
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
