module Dorsale
  module CustomerVault
    class LinksController < ::Dorsale::CustomerVault::ApplicationController
      before_action :load_linkable, only: [
        :new,
        :edit,
        :create,
        :update,
        :destroy
      ]

      def new
        authorize! :update, @person

        @link   ||= ::Dorsale::CustomerVault::Link.new
        @people ||= current_user_scope.people
      end

      def edit
        authorize! :update, @person

        @link = ::Dorsale::CustomerVault::Link.find(params[:id])
      end

      def create
        authorize! :update, @person

        params = link_params
        bob = params[:bob].split("-")

        @link ||= ::Dorsale::CustomerVault::Link.new(title: params[:title], alice_id: @person.id, alice_type: @person.class.to_s, bob_id: bob[1], bob_type: bob[0])

        if @link.save
          flash[:notice] = t("messages.links.create_ok")
          redirect_to url_for(@person) + "#links"
        else
          render :new
        end
      end

      def update
        authorize! :update, @person

        @link = ::Dorsale::CustomerVault::Link.find(params[:id])

        if @link.update(link_params)
          flash[:notice] = t("messages.links.update_ok")
          redirect_to url_for(@person) + "#links"
        else
          render :edit
        end
      end

      def destroy
        authorize! :update, @person

        @link = ::Dorsale::CustomerVault::Link.find(params[:id])

        if @link.destroy
          flash[:notice] = t("messages.links.destroy_ok")
        else
          flash[:alert] = t("messages.links.destroy_error")
        end

        redirect_to url_for(@person) + "#links"
      end


      private

      def load_linkable
        klass = [
          ::Dorsale::CustomerVault::Individual,
          ::Dorsale::CustomerVault::Corporation
        ].detect { |c| params["#{c.name.demodulize.underscore}_id"] }

        @person = klass.find(params["#{klass.name.demodulize.underscore}_id"])
      end

      def permitted_params
        [
          :bob,
          :title
        ]
      end

      def link_params
        params.require(:link).permit(permitted_params)
      end
    end
  end
end
