class Dorsale::BillingMachine::IdCardsController < ::Dorsale::BillingMachine::ApplicationController
  def index
    authorize! :list, model

    @id_cards ||= model.all
  end

  def new
    @id_card = model.new

    authorize! :create, @id_card
  end

  def create
    @id_card ||= model.new(id_card_params)

    authorize! :create, @id_card

    if @id_card.save
      flash[:notice] = t("id_cards.create_ok")
      redirect_to back_url
    else
      render action: "new"
    end
  end

  def edit
    @id_card = model.find(params[:id])

    authorize! :update, @id_card
  end

  def update
    @id_card = model.find(params[:id])

    authorize! :update, @id_card

    if @id_card.update_attributes(id_card_params)
      flash[:notice] = t("id_cards.update_ok")
      redirect_to back_url
    else
      render action: "edit"
    end
  end

  private

  def model
    ::Dorsale::BillingMachine::IdCard
  end

  def back_url
    url_for(action: :index, id: nil)
  end

  def permitted_params
    [
      :id,
      :id_card_name,
      :entity_name,
      :siret,
      :legal_form,
      :capital,
      :registration_number,
      :intracommunity_vat,
      :address1,
      :address2,
      :zip,
      :city,
      :phone,
      :contact_full_name,
      :contact_phone,
      :contact_address_1,
      :contact_address_2,
      :contact_zip,
      :contact_city,
      :iban,
      :bic_swift,
      :bank_name,
      :bank_address,
      :ape_naf,
      :custom_info_1,
      :custom_info_2,
      :custom_info_3,
      :contact_fax,
      :contact_email,
      :logo,
      :registration_city,
    ]
  end

  def id_card_params
    params.fetch(:billing_machine_id_card, {}).permit(permitted_params)
  end

end
