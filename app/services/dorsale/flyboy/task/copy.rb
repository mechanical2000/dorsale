class Dorsale::Flyboy::Task::Copy < ::Dorsale::Service
  attr_accessor :task, :copy

  def initialize(task)
    @task = task
  end

  def call
    @copy = @task.dup
    @copy.reminder_date = nil
    @copy.reminder_type = nil
    @copy.term = nil
    @copy.done = nil
    @copy.progress = nil
    @copy.assign_default_values
    @copy
  end
end
