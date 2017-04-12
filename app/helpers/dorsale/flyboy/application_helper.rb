module Dorsale::Flyboy::ApplicationHelper
  def tasks_for(taskable)
    @filters = ::Dorsale::Flyboy::SmallData::FilterForTasks.new(cookies)

    order ||= sortable_column_order do |column, direction|
      case column
      when :name, :status
        %(LOWER(dorsale_flyboy_tasks.#{column}) #{direction})
      when :progress, :term
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
    return "finished"  if task.done
    return "onalert"   if task.term < Time.zone.now.to_date
    return "onwarning" if task.reminder_date && task.reminder_date < Time.zone.now.to_date
    return "ontime"

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

  def flyboy_reminder_types_for_select
    {
      Dorsale::Flyboy::Task.t("reminder_type.none")     => "",
      Dorsale::Flyboy::Task.t("reminder_type.duration") => "duration",
      Dorsale::Flyboy::Task.t("reminder_type.custom")   => "custom",
    }
  end

  def flyboy_reminder_type_units_for_select
    {
      Dorsale::Flyboy::Task.t("reminder_unit.days")   => "days",
      Dorsale::Flyboy::Task.t("reminder_unit.weeks")  => "weeks",
      Dorsale::Flyboy::Task.t("reminder_unit.months") => "months",
    }
  end

  def task_term_values_for_select
    today     = Time.zone.now.to_date
    tomorrow  = (Time.zone.now + 1.day).to_date
    this_week = Time.zone.now.to_date.end_of_week
    next_week = (Time.zone.now + 1.week).to_date.end_of_week

    # Because today or tomorrow can be equal to this week
    if @task.term == today
      is_today = true
    elsif @task.term == tomorrow
      is_tomorrow = true
    elsif @task.term == this_week
      is_this_week = true
    elsif @task.term == next_week
      is_next_week = true
    else
      is_custom = true
    end

    [
      [Dorsale::Flyboy::Task.t("term_value.today"),     today.to_s,     {selected: is_today}],
      [Dorsale::Flyboy::Task.t("term_value.tomorrow"),  tomorrow.to_s,  {selected: is_tomorrow}],
      [Dorsale::Flyboy::Task.t("term_value.this_week"), this_week.to_s, {selected: is_this_week}],
      [Dorsale::Flyboy::Task.t("term_value.next_week"), next_week.to_s, {selected: is_next_week}],
      [Dorsale::Flyboy::Task.t("term_value.custom"),    :custom,        {selected: is_custom}],
    ]
  end

end
