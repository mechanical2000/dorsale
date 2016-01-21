namespace :cron do
  desc "Warn users for pending tasks"

  def log message
    #puts message if ENV["RAILS_ENV"] != "test"
  end

  task :daily => :environment do
    log 'Cron starting'
    date = Date.today
    Task.all.each do |task|
      Dorsale::Flyboy::TaskMailer.term_email(task).deliver_later if task.term == date && !task.done? && task.owner.present?
    end
  end
end