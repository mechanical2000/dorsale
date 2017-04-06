class Dorsale::CustomerVault::Corporation < Dorsale::CustomerVault::Person
  serialize      :data,  Dorsale::CustomerVault::CorporationData
  def_delegators :data, *Dorsale::CustomerVault::CorporationData.methods_to_delegate

  validates :corporation_name, presence: true
  has_many :individuals

  def name
    corporation_name
  end

  def name=(corporation_name)
    self.corporation_name = corporation_name
  end

  private def first_name;  raise NoMethodError; end
  private def first_name=; raise NoMethodError; end
  private def last_name;   raise NoMethodError; end
  private def last_name=;  raise NoMethodError; end
  private def corporation;   raise NoMethodError; end
  private def corporation=;  raise NoMethodError; end
  private def corporation_id;   raise NoMethodError; end
  private def corporation_id=;  raise NoMethodError; end

end
