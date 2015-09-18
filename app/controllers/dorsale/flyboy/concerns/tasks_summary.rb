module TasksSummary extend ActiveSupport::Concern
included do

    end
    module ClassMethods
      def setup_tasks_summary
        tasks = current_user_scope.tasks.where("(owner_id is null and owner_type is null) or (owner_id = ? and owner_type = ?)", current_user.id, current_user.class.name)
        @delayed_tasks   = tasks.delayed
        @today_tasks     = tasks.today
        @tomorrow_tasks  = tasks.tomorrow
        @this_week_tasks = tasks.this_week
        @next_week_tasks = tasks.next_week
      end
    end
end