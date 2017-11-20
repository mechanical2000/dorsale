module Dorsale::Flyboy::ApplicationHelper
  def tasks_for(taskable)
    @filters = ::Dorsale::Flyboy::SmallData::FilterForTasks.new(filters_jar)

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

  def flyboy_status_for_filters_select
    Dorsale::Flyboy::Task::STATES.map do |state|
      [Dorsale::Flyboy::Task.t("state.#{state}"), state]
    end
  end

  def flyboy_tasks_owners_for_select
    ([@task&.owner].compact + policy_scope(User).actives).uniq
  end

  def flyboy_tasks_owners_for_filters_select
    flyboy_tasks_owners_for_select
  end

  def flyboy_tasks_tags_for_select
    Dorsale::TagListForModel.(Dorsale::Flyboy::Task)
  end

  def flyboy_tasks_tags_for_filters_select
    flyboy_tasks_tags_for_select
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
    today     = Date.current
    tomorrow  = Date.tomorrow
    this_week = Date.current.end_of_week
    next_week = (Date.current + 1.week).end_of_week

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
