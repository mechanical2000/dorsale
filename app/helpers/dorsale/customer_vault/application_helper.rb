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

  def person_address_blank?(person)
    [
      person.address.street,
      person.address.street_bis,
      person.address.zip,
      person.address.city,
      person.address.country,
    ].all?(&:blank?)
  end

  def person_social_blank?(person)
    [
      person.skype,
      person.www,
      person.twitter,
      person.facebook,
      person.linkedin,
      person.viadeo,
      person.try(:societe_com),
    ].all?(&:blank?)
  end

  def person_related_people_blank?(person)
    person.individuals.empty?
  end
end
