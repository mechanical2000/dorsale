class Dorsale::Flyboy::Task::Snoozer < ::Dorsale::Service
  attr_reader :task

  def initialize(task)
    @task = task
  end

  def call
    snooze
  end

  def snooze
    if task.term
      task.term = task.term + snooze_term_value
    end

    if task.reminder_type == "custom"
      task.reminder_date = task.reminder_date + snooze_reminder_value
    end

    task.save
  end

  def snoozable?
    if task.done?
      false
    elsif task.reminder_date
      task.reminder_date <= current_date
    elsif task.term
      task.term <= current_date
    else
      false
    end
  end

  private

  def current_date
    Date.current
  end

  def snooze_term_value
    1.week
  end

  def snooze_reminder_value
    1.week
  end
end
