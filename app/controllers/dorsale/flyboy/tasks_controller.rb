class Dorsale::Flyboy::TasksController < ::Dorsale::Flyboy::ApplicationController
  include Dorsale::Flyboy::TasksSummaryConcern

  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :complete,
    :snooze
  ]

  def index
    authorize! :list, model

    @tasks ||= current_user_scope.tasks

    @order ||= sortable_column_order do |column, direction|
      case column
      when "name", "status"
        %(LOWER(dorsale_flyboy_tasks.#{column}) #{direction})
      when "progress", "term"
        %(dorsale_flyboy_tasks.#{column} #{direction})
      when "taskable"
        if direction == :asc
          proc { |a, b| a.taskable.name.downcase <=> b.taskable.name.downcase }
        else
          proc { |a, b| b.taskable.name.downcase <=> a.taskable.name.downcase }
        end
      else
        params["sort"] = "term"
        "term ASC"
      end
    end

    @filters ||= ::Dorsale::Flyboy::SmallData::FilterForTasks.new(cookies)

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

    respond_to do |format|
      format.html

      format.csv do
        send_data @tasks_without_pagination.to_csv,
          filename:    "feuille_de_route_#{Time.zone.now.to_date}.csv",
          disposition: "attachment"
      end

      format.xls

      format.pdf do
        pdf = Roadmap.new(@tasks_without_pagination)
        pdf.build
        send_data pdf.render,
          filename:    "feuille_de_route_#{Time.zone.now.to_date}.pdf",
          disposition: "inline"
      end
    end

  end

  def show
    @task = model.find(params[:id])

    authorize! :read, @task
  end

  def new
    @task = current_user_scope.new_task
    @task.taskable_guid = params[:taskable_guid]

    set_owners

    authorize! :create, @task
  end

  def create
    @task ||= current_user_scope.new_task(task_params)

    authorize! :create, @task

    if @task.save
      flash[:success] = t("messages.tasks.create_ok")
      notify_owner(current_user, @task)
      redirect_to back_url
    else
      set_owners
      render :new
    end
  end

  def edit
    authorize! :update, @task

    set_owners
  end

  def update
    authorize! :update, @task


    if @task.update_attributes(task_params)
      flash[:success] = t("messages.tasks.update_ok")
      redirect_to back_url
    else
      set_owners
      render :edit
    end
  end

  def destroy
    authorize! :delete, @task

    if @task.destroy
      flash[:success] = t("messages.tasks.delete_ok")
    else
      flash[:danger] = t("messages.tasks.delete_error")
    end

    redirect_to url_for(action: :index, id: nil)
  end

  def complete
    authorize! :complete, @task

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
    @task.snooze

    if @task.save
      flash[:success] = t("messages.tasks.snooze_ok")
    else
      flash[:danger] = t("messages.tasks.snooze_error")
    end

    redirect_to back_url
  end

  def summary
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

  def back_url
    url = super
    url << "#tasks" if url.include?("customer_vault")
    url
  end

  def notify_owner(author, task)
    return if author == task.owner
    return if task.owner.nil?
    Dorsale::Flyboy::TaskMailer.new_task(author, task).deliver_later
  end

  def set_objects
    @task     = model.find params[:id]
    @taskable = @task.taskable
  end

  def set_owners
    @owners ||= current_user_scope.colleagues(@task.taskable)
  end

  def permitted_params
    [
      :taskable_id,
      :taskable_type,
      :name,
      :description,
      :progress,
      :term,
      :reminder,
      :owner_guid,
    ]
  end

  def task_params
    params.fetch(:task, {}).permit(permitted_params)
  end

end
