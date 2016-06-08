module Dorsale
  module Alexandrie
    class AttachmentsController < ::Dorsale::ApplicationController
      layout false

      before_action :set_objects, only: [
        :edit,
        :update,
        :destroy,
      ]

      def index
        @attachable = find_attachable

        authorize! :read, @attachable
      end

      def create
        @attachment = ::Dorsale::Alexandrie::Attachment.new(attachment_params_for_create)

        authorize! :create, @attachment

        if @attachment.save
          flash[:notice] = t("messages.attachments.create_ok")
        else
          flash[:alert] = t("messages.attachments.create_error")
        end

        render_or_redirect
      end

      def edit
        authorize! :update, @attachment
      end

      def update
        authorize! :update, @attachment

        if @attachment.update_attributes(attachment_params_for_update)
          flash[:notice] = t("messages.attachments.update_ok")
        else
          flash[:alert] = t("messages.attachments.update_error")
        end

        render_or_redirect
      end

      def destroy
        authorize! :delete, @attachment

        if @attachment.destroy
          flash[:notice] = t("messages.attachments.delete_ok")
        else
          flash[:alert] = t("messages.attachments.delete_error")
        end

        render_or_redirect
      end

      private

      def set_objects
        @attachment = ::Dorsale::Alexandrie::Attachment.find params[:id]
      end

      def attachable_type
        params[:attachable_type] || @attachment.attachable_type
      end

      def attachable_id
        params[:attachable_id] || @attachment.attachable_id
      end

      def find_attachable
        attachable_type.to_s.constantize.find(attachable_id)
      rescue NameError
        raise ActiveRecord::RecordNotFound
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

      def render_or_redirect
        if request.xhr?
          render nothing: true
        else
          redirect_to params[:back_url] || request.referer
        end
      end

    end
  end
end
