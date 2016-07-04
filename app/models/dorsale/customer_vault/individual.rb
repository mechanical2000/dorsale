class Dorsale::CustomerVault::Individual < ActiveRecord::Base
  self.table_name = "dorsale_customer_vault_individuals"
  include ::Dorsale::CustomerVault::Person
  include ::Dorsale::Search

  validates :first_name, presence: true
  validates :last_name,  presence: true

  def name
    [self.last_name, self.first_name].join(", ")
  end

end
