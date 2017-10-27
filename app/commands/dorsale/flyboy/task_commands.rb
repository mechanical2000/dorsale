module Dorsale::Flyboy::TaskCommands
  def self.send_daily_term_emails!
    ::Dorsale::Flyboy::Task.all.each do |task|
      next if task.done?
      next if task.term != Date.current
      next if task.owner.nil?

      ::Dorsale::Flyboy::TaskMailer.term_email(task).deliver_later
    end
  end
end
