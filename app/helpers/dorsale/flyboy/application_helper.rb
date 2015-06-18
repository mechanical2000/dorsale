module Dorsale
  module Flyboy
    module ApplicationHelper

      def folder_color(folder)
        return "onalert"   if Dorsale::Flyboy::Task.where(taskable: folder).where('done = ? AND term < ?', false, Date.today).count > 0
        return "onwarning" if Dorsale::Flyboy::Task.where(taskable: folder).where('done = ? AND term > ? AND reminder < ?', false, Date.today, Date.today).count > 0
        return "finished"  if folder.closed?
        return "ontime"
      end

      def task_color(task)
        return "finished" if task.done
        return "ontime"   if task.reminder > Date.today
        return "onalert"  if task.term <  Date.today
        return "onwarning"
      end

    end
  end
end
