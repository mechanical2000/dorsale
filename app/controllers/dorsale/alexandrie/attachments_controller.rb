module Dorsale
  module Alexandrie
    class AttachmentsController < ::Dorsale::ApplicationController
      before_action :set_objects, only: [
        :edit,
        :update,
        :destroy,
      ]

      def create
        @attachment = ::Dorsale::Alexandrie::Attachment.new(attachment_params_for_create)

        authorize! :create, @attachment

        if @attachment.save
          flash[:notice] = t("messages.attachments.create_ok")
        else
          flash[:alert] = t("messages.attachments.create_error")
        end

        redirect_to_back_url
      end

      def edit
        authorize! :update, @attachment

        render layout: false
      end

      def update
        authorize! :update, @attachment

        if @attachment.update_attributes(attachment_params_for_update)
          flash[:notice] = t("messages.attachments.update_ok")
        else
          flash[:alert] = t("messages.attachments.update_error")
        end

        redirect_to_back_url
      end

      def destroy
        authorize! :delete, @attachment

        if @attachment.destroy
          flash[:notice] = t("messages.attachments.delete_ok")
        else
          flash[:alert] = t("messages.attachments.delete_error")
        end

        redirect_to_back_url
      end

      private

      def set_objects
        @attachment = ::Dorsale::Alexandrie::Attachment.find params[:id]
      end

      def permitted_params_for_create
        [
          :attachable_id,
          :attachable_type,
          :file,
          :name
        ]
      end

      def attachment_params_for_create
        params
          .require(:attachment)
          .permit(permitted_params_for_create)
          .merge(sender: current_user)
      end

      def permitted_params_for_update
        [
          :name,
        ]
      end

      def attachment_params_for_update
        params
          .require(:attachment)
          .permit(permitted_params_for_update)
      end

      def redirect_to_back_url
        redirect_to params[:back_url] || request.referer
      end
    end
  end
end
