module Dorsale::Flyboy::TasksSummaryConcern
  extend ActiveSupport::Concern

  def setup_tasks_summary
    tasks = policy_scope(::Dorsale::Flyboy::Task).where(owner: [current_user, nil])

    @delayed_tasks        = tasks.delayed
    @today_tasks          = tasks.today
    @tomorrow_tasks       = tasks.tomorrow
    @this_week_tasks      = tasks.this_week
    @next_week_tasks      = tasks.next_week
    @next_next_week_tasks = tasks.next_next_week
  end
end
