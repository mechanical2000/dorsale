module Dorsale
  module Flyboy
    class TaskMailer < ::Dorsale::ApplicationMailer
      def new_task(user, task)
        @author   = user
        @task = task
        mail(
          :to      => task.owner.email,
          :subject => t("emails.task.new.subject"),
        )
      end
    end
  end
end