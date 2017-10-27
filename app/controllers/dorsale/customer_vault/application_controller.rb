class Dorsale::CustomerVault::ApplicationController < ::Dorsale::ApplicationController
  before_action :set_form_variables, only: [
    :new,
    :create,
    :edit,
    :update,
  ]

  private

  def customer_vault_tag_list
    Dorsale::TagListForModel.(Dorsale::CustomerVault::Person)
  end

  def set_form_variables
    @tags ||= customer_vault_tag_list
  end
end
