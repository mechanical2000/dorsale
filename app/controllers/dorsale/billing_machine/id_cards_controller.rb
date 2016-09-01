module Dorsale
  module BillingMachine
    class IdCardsController < ::Dorsale::BillingMachine::ApplicationController
      def index
        authorize! :index, IdCard
        @idcards ||= ::Dorsale::BillingMachine::IdCard.all
      end

      def new
        @idcard = ::Dorsale::BillingMachine::IdCard.new
        authorize! :create, IdCard
      end

      def create
        @idcard = ::Dorsale::BillingMachine::IdCard.new(idcard_params)
        authorize! :create, IdCard
        if @idcard.save
          flash[:notice] = "Id Card successfully added"
          redirect_to billing_machine_id_cards_path
        else
          render action: "new"
        end
      end

      def edit
        @idcard = ::Dorsale::BillingMachine::IdCard.find(params[:id])
        authorize! :update, IdCard
      end

      def update
        @idcard = ::Dorsale::BillingMachine::IdCard.find(params[:id])
        authorize! :update, IdCard
        if @idcard.update_attributes(idcard_params)
          flash[:notice] = "Id Card successfully updated"
          redirect_to billing_machine_id_cards_path
        else
          render action: "edit"
        end
      end

      private

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

      def idcard_params
        params.require(:billing_machine_id_card).permit(permitted_params)
      end
    end
  end
end