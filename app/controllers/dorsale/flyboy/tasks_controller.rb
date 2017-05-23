class Dorsale::Flyboy::TasksController < ::Dorsale::Flyboy::ApplicationController
  include Dorsale::Flyboy::TasksSummaryConcern

  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :complete,
    :snooze,
    :copy,
  ]

  before_action :set_owners, only: [
    :new,
    :create,
    :edit,
    :update,
    :copy,
  ]

  def index
    authorize model, :list?

    @tasks ||= scope.all.preload(:taskable)

    @order ||= sortable_column_order do |column, direction|
      case column
      when :name, :status
        %(LOWER(dorsale_flyboy_tasks.#{column}) #{direction})
      when :progress, :term
        %(dorsale_flyboy_tasks.#{column} #{direction})
      when :taskable
        if direction == :asc
          proc { |a, b| a.taskable.to_s.downcase <=> b.taskable.to_s.downcase }
        else
          proc { |a, b| b.taskable.to_s.downcase <=> a.taskable.to_s.downcase }
        end
      else
        params["sort"] = "term"
        "term ASC"
      end
    end

    @filters ||= ::Dorsale::Flyboy::SmallData::FilterForTasks.new(filters_jar)

    @tasks = @filters.apply(@tasks)
    @tasks = @tasks.search(params[:q])

    if @order.is_a?(Proc) # when sorting by a polymorphic attribute
      @tasks = @tasks.sort(&@order)
      @tasks_without_pagination = @tasks
      @tasks = Kaminari.paginate_array(@tasks).page(params[:page])
    else
      @tasks = @tasks.order(@order)
      @tasks_without_pagination = @tasks
      @tasks = @tasks.page(params[:page])
    end
  end

  def show
    authorize @task, :read?
    @task_comments = @task.comments

    @order ||= sortable_column_order do |column, direction|
    case column
    when :description
        %(LOWER(#{column}) #{direction})
      when :progress
        %(#{column} #{direction})
      else
        "date #{direction}"
      end
    end
    @task_comments = @task_comments.reorder(@order)
  end

  def new
    @task ||= scope.new
    @task.owner ||= current_user
    @task.taskable_guid = params[:taskable_guid]

    authorize @task, :create?
  end

  def create
    @task ||= scope.new(task_params)

    authorize @task, :create?

    if @task.save
      flash[:success] = t("messages.tasks.create_ok")
      notify_owner(current_user, @task)
      redirect_to back_url
    else
      render :new
    end
  end

  def edit
    authorize @task, :update?

  end

  def update
    authorize @task, :update?

    if @task.update(task_params)
      flash[:success] = t("messages.tasks.update_ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize @task, :delete?

    if @task.destroy
      flash[:success] = t("messages.tasks.delete_ok")
    else
      flash[:danger] = t("messages.tasks.delete_error")
    end

    redirect_to url_for(action: :index, id: nil)
  end

  def complete
    authorize @task, :complete?

    @task_comment ||= @task.comments.new(
      :progress    => 100,
      :description => t("messages.tasks.complete_ok"),
      :date        => Time.zone.now,
      :author      => current_user
    )

    if @task_comment.save
      flash[:success] = t("messages.tasks.complete_ok")
    else
      flash[:danger] = t("messages.tasks.complete_error")
    end

    redirect_to back_url
  end

  def snooze
    authorize @task, :snooze?

    if @task.snoozer.snooze
      comment = Dorsale::Flyboy::TaskComment.new(task: @task, progress: @task.progress, description: t("messages.tasks.snooze_ok"), author: current_user)
      comment.save!
      flash[:success] = t("messages.tasks.snooze_ok")
    else
      flash[:danger] = t("messages.tasks.snooze_error")
    end

    redirect_to back_url
  end

  def copy
    authorize @task, :copy?

    @original = @task
    @task  = Dorsale::Flyboy::Task::Copy.(@original)
    render :new
  end

  def summary
    authorize model, :list?

    setup_tasks_summary
  end

  private

  def model
    ::Dorsale::Flyboy::Task
  end

  def default_back_url
    if @task
      url_for(action: :show, id: @task.to_param)
    else
      url_for(action: :index, id: nil)
    end
  end

  def notify_owner(author, task)
    return if author == task.owner
    return if task.owner.nil?
    Dorsale::Flyboy::TaskMailer.new_task(task, author).deliver_later
  end

  def set_objects
    @task     ||= scope.find(params[:id])
    @taskable ||= @task.taskable
  end

  def set_owners
    @owners ||= policy_scope(User).all
  end

  def permitted_params
    [
      :taskable_id,
      :taskable_type,
      :name,
      :description,
      :progress,
      :term,
      :reminder_type,
      :reminder_date,
      :reminder_duration,
      :reminder_unit,
      :owner_id,
    ]
  end

  def task_params
    params.fetch(:task, {}).permit(permitted_params)
  end

end
