module Dorsale::AllHelpers
  include ::ActionView::Helpers::NumberHelper
  include ::Agilibox::AllHelpers

  include ::Dorsale::ContextHelper

  include ::Dorsale::CommentsHelper
  include ::Dorsale::Alexandrie::AttachmentsHelper
  include ::Dorsale::BillingMachine::ApplicationHelper
  include ::Dorsale::CustomerVault::ApplicationHelper
  include ::Dorsale::Flyboy::ApplicationHelper
  include ::Dorsale::ExpenseGun::ApplicationHelper
  include ::Dorsale::UsersHelper

  extend self
end
