require "dorsale/search"
require "dorsale/polymorphic_id"

module Dorsale
  module Flyboy
    class Task < ActiveRecord::Base
      self.table_name = "dorsale_flyboy_tasks"

      include ::Dorsale::Search

      paginates_per 50

      belongs_to :taskable, polymorphic: true
      belongs_to :owner, polymorphic: true
      has_many :comments, class_name: ::Dorsale::Flyboy::TaskComment, inverse_of: :task, dependent: :destroy
      polymorphic_id_for :taskable
      polymorphic_id_for :owner

      scope :delayed, -> { where('term < ?', Date.today).where(done: false)}
      scope :today, -> { where('term = ?', Date.today).where(done: false)}
      scope :tomorrow, -> { where('term = ?', Date.tomorrow).where(done: false)}
      scope :this_week, -> { where('term > ?', Date.tomorrow).where('term <= ?', Date.today.end_of_week).where(done: false)}
      scope :next_week, -> { where('term > ?', Date.today.end_of_week).where('term <= ?', (Date.today.end_of_week+1).end_of_week).where(done: false)}

      validates :taskable, presence: true
      validates :name,    presence: true
      validates :term,     presence: true
      validates :reminder, presence: true

      validate :validates_reminder_and_term

      def validates_reminder_and_term
        if reminder && term && reminder > term
          # errors.add(:reminder, "La date de relance doit être antérieure ou égale à la date d'échéance")
          errors.add(:reminder, :less_than, count: term)
        end
      end

      def initialize(*args)
        super
        self.done = false                                    if done.nil?
        self.reminder = Date.today + snooze_default_reminder if reminder.nil?
        self.term     = Date.today + snooze_default_term     if term.nil?
        self.progress = 0                                    if progress.nil?
      end

      after_save    :update_taskable_progress!
      after_destroy :update_taskable_progress!

      def update_taskable_progress!
        taskable.try(:update_progress!)
      end

      def snooze
        if term_not_passed_yet
          if self.reminder + snooze_default_reminder > Date.today
            self.reminder += snooze_default_reminder
            self.term     += snooze_default_term
          else
            self.reminder = Date.today + 1
          end
        else
          self.reminder = Date.today + snooze_default_reminder
          self.term     = Date.today + snooze_default_term
        end
      end

      def snooze_default_reminder
        7
      end

      def snooze_default_term
        30
      end

      def self.to_csv(options = {})
        CSV.generate(options) do |csv|
          csv << [
            "Taskable",
            "Type",
            "Avancement taskable",
            "Tâche",
            "Avancement tâche",
            "Echéance"
          ]

          all.each do |task|
            csv << [
              task.taskable.name,
              task.taskable.class.t,
              "#{task.taskable.try(:progress)} %",
              task.name,
              "#{task.progress} %",
              I18n.l(task.term),
            ]
          end
        end
      end

      def term_not_passed_yet
        self.term > Date.today
      end
    end
  end
end
