module Dorsale::CustomerVault::ApplicationHelper
  def customer_vault_link_form_path(person = @person, link = @link)
    if link.new_record?
      customer_vault_person_links_path(person, link)
    else
      customer_vault_person_link_path(person)
    end
  end

  def person_types_for_filter_select
    [
      [Dorsale::CustomerVault::Corporation.t, "Dorsale::CustomerVault::Corporation"],
      [Dorsale::CustomerVault::Individual.t,  "Dorsale::CustomerVault::Individual"],
    ]
  end
end
