class Dorsale::Flyboy::TaskComment < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_flyboy_task_comments"

  belongs_to :task
  belongs_to :author, class_name: User

  validates :author,      presence: true
  validates :task,        presence: true
  validates :date,        presence: true
  validates :description, presence: true
  validates :progress,    inclusion: {in: 0..100}

  default_scope -> { order(date: :desc) }

  def assign_default_values
    assign_default :date,     Time.zone.now
    assign_default :progress, (task ? task.progress : 0)
  end

  after_create :update_task_progress

  def update_task_progress
    task.update!(
      :progress => progress,
      :done     => progress.equal?(100),
    )
  end
end
