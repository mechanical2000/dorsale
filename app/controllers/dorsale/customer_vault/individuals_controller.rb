module Dorsale
  module CustomerVault
    class IndividualsController < ::Dorsale::CustomerVault::ApplicationController
      before_action :set_individual, only: [
        :show,
        :edit,
        :update,
        :destroy
      ]

      def show
        authorize! :read, @individual
      end

      def new
        authorize! :create, ::Dorsale::CustomerVault::Individual

        @individual ||= current_user_scope.new_individual
        @individual.build_address if @individual.address.nil?

        @tags ||= customer_vault_tag_list
      end

      def edit
        authorize! :update, @individual

        @individual.build_address if @individual.address.nil?

        @tags ||= customer_vault_tag_list
      end

      def create
        authorize! :create, ::Dorsale::CustomerVault::Individual

        @individual ||= current_user_scope.new_individual(individual_params)

        if @individual.save
          flash[:notice] = t("messages.individuals.create_ok")
          redirect_to @individual
        else
          render :new
        end
      end

      def update
        authorize! :update, @individual

        if @individual.update(individual_params)
          flash[:notice] = t("messages.individuals.update_ok")
          redirect_to @individual
        else
          render :edit
        end
      end

      def destroy
        authorize! :delete, @individual

        if @individual.destroy
          flash[:notice] = t("messages.individuals.destroy_ok")
        else
          flash[:alert] = t("messages.individuals.destroy_error")
        end

        redirect_to dorsale.customer_vault_people_path
      end

      private

      def set_individual
        @individual = ::Dorsale::CustomerVault::Individual.find(params[:id])
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
        params.require(:individual).permit(permitted_params)
      end

    end
  end
end
