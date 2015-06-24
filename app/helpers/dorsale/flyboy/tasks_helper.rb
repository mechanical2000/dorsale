module Dorsale
  module Flyboy
    module TasksHelper
      def tasks_for(taskable)
        @filters = ::Dorsale::Flyboy::SmallData::FilterForTasks.new(cookies)
        tasks = ::Dorsale::Flyboy::Task.where(taskable: taskable)
        tasks = @filters.apply(tasks)
        render "dorsale/flyboy/tasks/tasks_for_taskable", tasks: tasks, taskable: taskable
      end
    end
  end
end
