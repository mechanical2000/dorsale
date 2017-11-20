class Dorsale::Flyboy::Task < ::Dorsale::ApplicationRecord
  REMINDER_TYPES = %w(duration custom)
  REMINDER_UNITS = %w(days weeks months)

  self.table_name = "dorsale_flyboy_tasks"

  include ::Agilibox::Search

  paginates_per 50

  belongs_to :taskable, polymorphic: true, required: false
  belongs_to :owner, class_name: User
  has_many :comments, class_name: ::Dorsale::Flyboy::TaskComment, inverse_of: :task, dependent: :destroy

  polymorphic_id_for :taskable
  polymorphic_id_for :owner

  acts_as_taggable
  def tag_list
    super.sort
  end

  STATES = %w(done undone ontime onwarning onalert)

  def state
    return "done"      if done
    return "onalert"   if term          && term          <= Date.current
    return "onwarning" if reminder_date && reminder_date <= Date.current
    return "ontime"
  end

  scope :done,   -> { where(done: true)  }
  scope :undone, -> { where(done: false) }

  scope :ontime, -> {
    undone
      .where("#{table_name}.term IS NULL OR #{table_name}.term > ?", Date.current)
      .where("#{table_name}.reminder_date IS NULL OR #{table_name}.reminder_date > ?", Date.current)
  }

  scope :onwarning, -> {
    undone
      .where("#{table_name}.reminder_date <= ?", Date.current)
      .where("#{table_name}.term IS NULL OR #{table_name}.term > ?", Date.current)
  }

  scope :onalert, -> {
    undone
      .where("#{table_name}.term <= ?", Date.current)
  }

  scope :delayed,  -> { where(done: false).where("#{table_name}.term < ?", Date.current)  }
  scope :today,    -> { where(done: false).where("#{table_name}.term = ?", Date.current)  }
  scope :tomorrow, -> { where(done: false).where("#{table_name}.term = ?", Date.tomorrow) }

  scope :this_week, -> {
    min = Date.tomorrow
    max = Date.current.end_of_week
    where(done: false).where("#{table_name}.term > ?", min).where("#{table_name}.term <= ?", max)
  }

  scope :next_week, -> {
    min = Date.current.end_of_week
    max = Date.current.next_week.end_of_week
    where(done: false).where("#{table_name}.term > ?", min).where("#{table_name}.term <= ?", max)
  }

  scope :next_next_week, -> {
    min = Date.current.next_week.end_of_week
    max = Date.current.next_week.next_week.end_of_week
    where(done: false).where("#{table_name}.term > ?", min).where("#{table_name}.term <= ?", max)
  }

  validates :name,          presence: true
  validates :term,          presence: true
  validates :reminder_type, inclusion: {in: REMINDER_TYPES}, allow_blank: true
  validates :reminder_unit, inclusion: {in: REMINDER_UNITS}, allow_blank: true
  validates :reminder_date, presence: true, if: proc { reminder_type.present? }

  validate :validates_reminder_date

  def assign_default_values
    assign_default :progress, 0
    assign_default :done,     false
    assign_default :term,     Date.current.end_of_week
  end

  def snoozer
    @snoozer ||= Snoozer.new(self)
  end

  def term=(value)
    super
    auto_update_reminder_date
  end

  def reminder_type=(value)
    super
    auto_update_reminder_date
  end

  def reminder_duration=(value)
    super
    auto_update_reminder_date
  end

  def reminder_unit=(value)
    super
    auto_update_reminder_date
  end

  private

  def auto_update_reminder_date
    if reminder_type.blank?
      self.reminder_date = nil
    end

    if reminder_type == "duration" && term && reminder_duration && reminder_unit.in?(REMINDER_UNITS)
      self.reminder_date = term - reminder_duration.public_send(reminder_unit)
    end

    true
  end

  def validates_reminder_date
    if term && reminder_date && reminder_date > term
      errors.add(:reminder_date, :less_than, count: term)
    end
  end
end
