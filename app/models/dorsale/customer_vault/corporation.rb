class Dorsale::CustomerVault::Corporation < Dorsale::CustomerVault::Person
  data_attributes = %i(
    legal_form
    immatriculation_number
    naf
    european_union_vat_number
    societe_com
    capital
    revenue
    number_of_employees
  )
  store :data, accessors: data_attributes, coder: JSON

  validates :corporation_name, presence: true
  has_many :individuals, dependent: :nullify

  def self_and_related_events
    ::Dorsale::CustomerVault::Event.where(person: [self] + individuals)
  end

  def name
    corporation_name
  end

  def name=(corporation_name)
    self.corporation_name = corporation_name
  end

  # rubocop:disable Style/SingleLineMethods
  private def first_name;      raise NoMethodError; end
  private def first_name=;     raise NoMethodError; end
  private def last_name;       raise NoMethodError; end
  private def last_name=;      raise NoMethodError; end
  private def corporation;     raise NoMethodError; end
  private def corporation=;    raise NoMethodError; end
  private def corporation_id;  raise NoMethodError; end
  private def corporation_id=; raise NoMethodError; end
  # rubocop:enable Style/SingleLineMethods
end
