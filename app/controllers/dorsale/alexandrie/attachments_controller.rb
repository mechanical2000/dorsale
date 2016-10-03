class Dorsale::Alexandrie::AttachmentsController < ::Dorsale::ApplicationController
  layout false

  before_action :set_objects, only: [
    :edit,
    :update,
    :destroy,
  ]

  before_action :set_attachment_types

  def index
    @attachable = find_attachable
    skip_policy_scope

    authorize @attachable, :read?

    @attachment = scope.new(attachment_params_for_create)
  end

  def create
    @attachment = scope.new(attachment_params_for_create)

    authorize @attachment, :create?

    if @attachment.save
      # flash[:notice] = t("messages.attachments.create_ok")
    else
      flash[:alert] = t("messages.attachments.create_error")
    end

    render_or_redirect
  end

  def edit
    authorize @attachment, :update?

    @attachable = @attachment.attachable

    render :index
  end

  def update
    authorize @attachment, :update?

    if @attachment.update(attachment_params_for_update)
      # flash[:notice] = t("messages.attachments.update_ok")
    else
      flash[:alert] = t("messages.attachments.update_error")
    end

    render_or_redirect
  end

  def destroy
    authorize @attachment, :delete?

    if @attachment.destroy
      # flash[:notice] = t("messages.attachments.delete_ok")
    else
      flash[:alert] = t("messages.attachments.delete_error")
    end

    render_or_redirect
  end

  private

  def model
    ::Dorsale::Alexandrie::Attachment
  end

  def scope
    policy_scope(model)
  end

  def set_objects
    @attachment = scope.find(params[:id])
  end

  def set_attachment_types
    @attachment_types = policy_scope(::Dorsale::Alexandrie::AttachmentType).all
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

  def common_permitted_params
    [
      :name,
      :attachment_type_id
    ]
  end

  def permitted_params_for_create
    common_permitted_params + [
      :attachable_id,
      :attachable_type,
      :file,
    ]
  end

  def attachment_params_for_create
    params
      .fetch(:attachment, {})
      .permit(permitted_params_for_create)
      .merge(sender: current_user)
  end

  def permitted_params_for_update
    common_permitted_params
  end

  def attachment_params_for_update
    params
      .fetch(:attachment, {})
      .permit(permitted_params_for_update)
  end

  def render_or_redirect
    if request.xhr?
      head :ok
    else
      redirect_to back_url
    end
  end

end
