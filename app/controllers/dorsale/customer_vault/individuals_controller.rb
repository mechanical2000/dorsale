class Dorsale::CustomerVault::IndividualsController < ::Dorsale::CustomerVault::ApplicationController
  before_action :set_individual, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  def show
    authorize @individual, :read?
  end

  def new
    authorize model, :create?

    @individual ||= current_user_scope.new_individual
    @individual.build_address if @individual.address.nil?

    @tags ||= customer_vault_tag_list
  end

  def edit
    authorize @individual, :update?

    @individual.build_address if @individual.address.nil?

    @tags ||= customer_vault_tag_list
  end

  def create
    authorize model, :create?

    @individual ||= current_user_scope.new_individual(individual_params)

    if @individual.save
      flash[:notice] = t("messages.individuals.create_ok")
      redirect_to back_url
    else
      render :new
    end
  end

  def update
    authorize @individual, :update?

    if @individual.update(individual_params)
      flash[:notice] = t("messages.individuals.update_ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize @individual, :delete?

    if @individual.destroy
      flash[:notice] = t("messages.individuals.delete_ok")
    else
      flash[:alert] = t("messages.individuals.delete_error")
    end

    redirect_to customer_vault_people_path
  end

  private

  def model
    ::Dorsale::CustomerVault::Individual
  end

  def back_url
    url_for(@individual)
  end

  def set_individual
    @individual = model.find(params[:id])
  end

  def permitted_params
    [
      :first_name,
      :last_name,
      :short_name,
      :email,
      :title,
      :twitter,
      :www,
      :context,
      :phone,
      :fax,
      :mobile,
      :skype,
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

  def individual_params
    params.fetch(:individual, {}).permit(permitted_params)
  end

end
