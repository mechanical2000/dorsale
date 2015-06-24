module Dorsale
  module CustomerVault
    class CorporationsController < ::Dorsale::CustomerVault::ApplicationController
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
        authorize! :create, ::Dorsale::CustomerVault::Corporation

        @corporation ||= ::Dorsale::CustomerVault::Corporation.new

        @corporation.build_address if @corporation.address.nil?
      end

      def create
        authorize! :create, ::Dorsale::CustomerVault::Corporation

        @corporation ||= ::Dorsale::CustomerVault::Corporation.new(corporation_params)

        if @corporation.save
          flash[:notice] = t("messages.corporations.create_ok")
          redirect_to @corporation
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
          redirect_to @corporation
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

        redirect_to dorsale.customer_vault_people_path
      end

      private

      def set_corporation
        @corporation = ::Dorsale::CustomerVault::Corporation.find(params[:id])
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
        params.require(:corporation).permit(permitted_params)
      end

    end
  end
end
