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

  has_many :comments, class_name: ::Dorsale::Comment, as: :commentable, dependent: :destroy
  has_one :address, class_name: ::Dorsale::Address, as: :addressable, inverse_of: :addressable, dependent: :destroy
  has_many :tasks, class_name: ::Dorsale::Flyboy::Task, as: :taskable, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :invoices, class_name: ::Dorsale::BillingMachine::Invoice, as: :customer
  accepts_nested_attributes_for :address, allow_destroy: true

  belongs_to :activity_type, class_name: ::Dorsale::CustomerVault::ActivityType
  belongs_to :origin, class_name: ::Dorsale::CustomerVault::Origin

  after_destroy :destroy_links

  default_scope -> {
    order("LOWER(COALESCE(corporation_name, '') || COALESCE(last_name, '') || COALESCE(first_name, '')) ASC")
  }

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
      .each { |l| l.person = l.alice ; l.other_person = l.bob }

    b = ::Dorsale::CustomerVault::Link
      .where(bob_id: id)
      .preload(:alice => :taggings, :bob => :taggings)
      .each { |l| l.person = l.bob ; l.other_person = l.alice }

    return a + b
  end

  def destroy_links
    links.each(&:destroy!)
  end

  def receive_comment_notification(comment, action)
    if action == :create
      scope = Pundit.policy_scope!(comment.author, ::Dorsale::CustomerVault::Event)
      scope.create!(
        :author  => comment.author,
        :person  => self,
        :comment => comment,
        :action  => "comment",
      )
    end
  end

end
