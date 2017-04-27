class Dorsale::CustomerVault::Individual < Dorsale::CustomerVault::Person
  serialize      :data,  Dorsale::CustomerVault::IndividualData
  def_delegators :data, *Dorsale::CustomerVault::IndividualData.methods_to_delegate

  validates :first_name, presence: true
  validates :last_name,  presence: true
  belongs_to :corporation

  def self_and_related_events
    events
  end

  def name
    [self.last_name, self.first_name].join(", ")
  end

  def activity_type
    corporation.try(:activity_type)
  end

  private def corporation_name;  raise NoMethodError; end
  private def corporation_name=; raise NoMethodError; end
  private def activity_type=; raise NoMethodError; end
  private def activity_type_id;  raise NoMethodError; end
  private def activity_type_id=; raise NoMethodError; end
end
