class Dorsale::CustomerVault::Individual < Dorsale::CustomerVault::Person
  data_attributes = %i(
    title
  )
  store :data, accessors: data_attributes, coder: JSON

  validates :first_name, presence: true
  validates :last_name,  presence: true
  belongs_to :corporation

  def self_and_related_events
    events
  end

  def name
    [last_name, first_name].join(", ")
  end

  def activity_type
    corporation.try(:activity_type)
  end

  # rubocop:disable Style/SingleLineMethods
  private def corporation_name;  raise NoMethodError; end
  private def corporation_name=; raise NoMethodError; end
  private def activity_type=;    raise NoMethodError; end
  private def activity_type_id;  raise NoMethodError; end
  private def activity_type_id=; raise NoMethodError; end
  # rubocop:enable Style/SingleLineMethods
end
