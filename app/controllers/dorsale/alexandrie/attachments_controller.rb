class Dorsale::Alexandrie::AttachmentsController < ::Dorsale::ApplicationController
  layout false

  before_action :set_attachment, only: [
    :edit,
    :update,
    :destroy,
  ]

  before_action :set_attachment_types

  def index
    @attachable = find_attachable_from_params

    authorize @attachable, :read?

    render_list
  end

  def create
    @attachment = scope.new(attachment_params_for_create)

    authorize @attachment, :create?

    if @attachment.save
      notify_attachable
    else
      flash.now[:alert] = t("messages.attachments.create_error")
    end

    render_list
  end

  def edit
    authorize @attachment, :update?

    render_list
  end

  def update
    authorize @attachment, :update?

    if @attachment.update(attachment_params_for_update)
      notify_attachable
    else
      flash.now[:alert] = t("messages.attachments.update_error")
    end

    render_list
  end

  def destroy
    authorize @attachment, :delete?

    if @attachment.destroy
      notify_attachable
    else
      flash.now[:alert] = t("messages.attachments.delete_error")
    end

    render_list
  end

  private

  def model
    ::Dorsale::Alexandrie::Attachment
  end

  def set_attachment
    @attachment = scope.find(params[:id])
  end

  def set_attachment_types
    @attachment_types = policy_scope(::Dorsale::Alexandrie::AttachmentType).all
  end

  def find_attachable_from_params
    params[:attachable_type].to_s.constantize.find(params[:attachable_id])
  rescue NameError
    raise ActiveRecord::RecordNotFound
  end

  def common_permitted_params
    [
      :name,
      :attachment_type_id,
      :file,
    ]
  end

  def permitted_params_for_create
    common_permitted_params + [
      :attachable_id,
      :attachable_type,
    ]
  end

  def attachment_params_for_create
    params.fetch(:attachment, {}).permit(permitted_params_for_create)
      .merge(sender: current_user)
  end

  def permitted_params_for_update
    common_permitted_params
  end

  def attachment_params_for_update
    params.fetch(:attachment, {}).permit(permitted_params_for_update)
  end

  def render_list
    @new_attachment = scope.new
    @attachable = @attachment.attachable if @attachable.nil?
    @attachments = scope.where(attachable: @attachable).preload(:attachment_type)
    @attachments = Dorsale::Alexandrie::AttachmentsSorter.call(@attachments, params["sort"])
    render :index
  end

  def notify_attachable
    @attachment.attachable.send(:try, :after_attachments_changes)
  end
end
