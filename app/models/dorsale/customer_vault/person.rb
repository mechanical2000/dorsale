class Dorsale::CustomerVault::Person < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_customer_vault_people"

  extend Forwardable
  include ::Agilibox::Search
  include ::Dorsale::Users::Avatar

  def self.policy_class
    Dorsale::CustomerVault::PersonPolicy
  end

  after_initialize :verify_class

  def verify_class
    if self.class == ::Dorsale::CustomerVault::Person
      # self.abstract_class does not work with STI
      raise "Cannot directly instantiate Person class"
    end
  end

  acts_as_taggable

  has_many :comments, class_name: "Dorsale::Comment", as: :commentable, dependent: :destroy
  has_one :address, class_name: "Dorsale::Address", as: :addressable, inverse_of: :addressable, dependent: :destroy
  has_many :tasks, class_name: "Dorsale::Flyboy::Task", as: :taskable, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :invoices, class_name: "Dorsale::BillingMachine::Invoice", as: :customer, dependent: :nullify
  accepts_nested_attributes_for :address, allow_destroy: true

  belongs_to :activity_type, class_name: "Dorsale::CustomerVault::ActivityType"
  belongs_to :origin, class_name: "Dorsale::CustomerVault::Origin"

  after_destroy :destroy_links

  default_scope -> {
    order_by_name
  }

  scope :order_by_name, -> {
    sql = %(
      LOWER(
        COALESCE(corporation_name, '') ||
        COALESCE(last_name, '') ||
        COALESCE(first_name, '')
      ) ASC
    )

    order(Arel.sql sql)
  }

  scope :having_email, -> (email) { where("email = :e OR :e = ANY (secondary_emails)", e: email) }

  after_initialize  :build_address, if: proc { new_record? && address.nil? }
  before_validation :build_address, if: proc { address.nil? }

  def taken_emails
    taken_emails = {}
    ([email] + secondary_emails).select(&:present?).each do |e|
      person = Dorsale::CustomerVault::Person.where.not(id: id).having_email(e).first
      taken_emails[e] = person if person.present?
    end
    taken_emails
  end

  validate :validate_taken_emails

  def validate_taken_emails
    return if taken_emails.empty?

    if taken_emails.key?(email)
      errors.add(:email, :taken)
    end

    if (taken_emails.keys & secondary_emails).any?
      errors.add(:secondary_emails, :taken)
      errors.add(:secondary_emails_str, :taken)
    end
  end

  def email=(incoming_email)
    super(incoming_email.to_s.strip.presence)
  end

  def secondary_emails_str
    secondary_emails.join("\n")
  end

  def secondary_emails_str=(emails)
    self.secondary_emails = emails.strip.split
  end

  def person_type
    self.class.to_s.demodulize.downcase.to_sym
  end

  def corporation?
    person_type == :corporation
  end

  def individual?
    person_type == :individual
  end

  def tags_on(*args)
    super(*args).order(:name)
  end

  def links
    a = ::Dorsale::CustomerVault::Link
      .where(alice_id: id)
      .preload(:alice => :taggings, :bob => :taggings)
      .to_a
      .each { |l| l.person = l.alice; l.other_person = l.bob }

    b = ::Dorsale::CustomerVault::Link
      .where(bob_id: id)
      .preload(:alice => :taggings, :bob => :taggings)
      .to_a
      .each { |l| l.person = l.bob; l.other_person = l.alice }

    return a + b
  end

  def destroy_links
    links.each(&:destroy!)
  end
end
