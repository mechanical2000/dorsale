module Dorsale
  module Flyboy
    module ApplicationHelper
      include ::Handles::SortableColumns::InstanceMethods

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

      def setup_tasks_summary
        tasks = current_user_scope.tasks.where("(owner_id is null and owner_type is null) or (owner_id = ? and owner_type = ?)", current_user.id, current_user.class.name)
        @delayed_tasks   = tasks.delayed
        @today_tasks     = tasks.today
        @tomorrow_tasks  = tasks.tomorrow
        @this_week_tasks = tasks.this_week
        @next_week_tasks = tasks.next_week
      end

      def show_tasks_summary
        render "dorsale/flyboy/tasks/summary"
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
