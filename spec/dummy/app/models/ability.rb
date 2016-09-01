class Ability
  include CanCan::Ability
  include ::Dorsale::AbilityHelper
  include ::Dorsale::Alexandrie::AbilityHelper
  include ::Dorsale::Flyboy::AbilityHelper
  include ::Dorsale::BillingMachine::AbilityHelper
  include ::Dorsale::CustomerVault::AbilityHelper
  include ::Dorsale::ExpenseGun::AbilityHelper

  def initialize(*)
    define_alexandrie_abilities
    define_dorsale_comment_abilities
    define_user_abilities
    define_dorsale_flyboy_abilities
    define_dorsale_billing_machine_abilities
    define_dorsale_customer_vault_abilities
    define_dorsale_expense_gun_abilities
    define_dorsale_expense_gun_categories
  end
end
