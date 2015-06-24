module Dorsale
  module Flyboy
    module ApplicationHelper

      def tasks_for(taskable)
        @filters = ::Dorsale::Flyboy::SmallData::FilterForTasks.new(cookies)
        tasks = ::Dorsale::Flyboy::Task.where(taskable: taskable)
        tasks = @filters.apply(tasks)
        render "dorsale/flyboy/tasks/tasks_for_taskable", tasks: tasks, taskable: taskable
      end

      def task_color(task)
        return "finished" if task.done
        return "ontime"   if task.reminder > Date.today
        return "onalert"  if task.term <  Date.today
        return "onwarning"
      end

      def folder_color(folder)
        return "onalert"   if ::Dorsale::Flyboy::Task.where(taskable: folder).where('done = ? AND term < ?', false, Date.today).count > 0
        return "onwarning" if ::Dorsale::Flyboy::Task.where(taskable: folder).where('done = ? AND term > ? AND reminder < ?', false, Date.today, Date.today).count > 0
        return "finished"  if folder.closed?
        return "ontime"
      end

    end
  end
end
