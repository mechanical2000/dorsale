module Dorsale
  module Flyboy
    module AbilityHelper
      def define_dorsale_flyboy_abilities
        # Allowed actions (all by default)
        can [:list, :create, :read, :update, :delete, :open, :close], ::Dorsale::Flyboy::Goal
        can [:list, :create, :read, :update, :delete, :complete, :snooze], ::Dorsale::Flyboy::Task

        # Restricted actions

        cannot [:update, :delete], ::Dorsale::Flyboy::Goal do |goal|
          goal.closed?
        end

        cannot :close, ::Dorsale::Flyboy::Goal do |goal|
          not goal.may_close?
        end

        cannot :open, ::Dorsale::Flyboy::Goal do |goal|
          not goal.may_open?
        end

        cannot :create, ::Dorsale::Flyboy::Task do |task|
          task.taskable.present? && cannot?(:show, task.taskable)
        end

        cannot [:create, :update, :delete], ::Dorsale::Flyboy::Task do |task|
          task.taskable.is_a?(::Dorsale::Flyboy::Goal) && task.taskable.closed?
        end

        cannot :complete, ::Dorsale::Flyboy::Task do |task|
          task.done?
        end

        cannot :snooze, ::Dorsale::Flyboy::Task do |task|
          task.done? || task.reminder >= Date.today
        end
      end
    end
  end
end
