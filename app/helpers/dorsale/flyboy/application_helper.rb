module Dorsale::Flyboy::ApplicationHelper
  def tasks_for(taskable)
    @filters = ::Dorsale::Flyboy::SmallData::FilterForTasks.new(cookies)

    order ||= sortable_column_order do |column, direction|
      case column
      when "name", "status"
        %(LOWER(dorsale_flyboy_tasks.#{column}) #{direction})
      when "progress", "term"
        %(dorsale_flyboy_tasks.#{column} #{direction})
      else
        params["sort"] = "term"
        "dorsale_flyboy_tasks.term ASC"
      end
    end

    tasks = ::Dorsale::Flyboy::Task.where(taskable: taskable)
    tasks = @filters.apply(tasks)
    tasks = tasks.order(order)

    render "dorsale/flyboy/tasks/tasks_for_taskable", tasks: tasks, taskable: taskable
  end

  def show_tasks_summary
    render "dorsale/flyboy/tasks/summary"
  end

  def task_color(task)
    return "finished" if task.done
    return "ontime"   if task.reminder > Time.zone.now.to_date
    return "onalert"  if task.term     < Time.zone.now.to_date
    return "onwarning"
  end

  def flyboy_status_for_filters_select
    {
      Dorsale::Flyboy::Task.t("status.all")    => "",
      Dorsale::Flyboy::Task.t("status.open")   => "open",
      Dorsale::Flyboy::Task.t("status.closed") => "closed",
    }
  end

  def flyboy_tasks_owners_for_filters_select
    policy_scope(User)
  end

end
