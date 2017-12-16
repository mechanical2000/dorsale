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

  def customer_vault_event_actions_for_filter_select
    model = Dorsale::CustomerVault::Event
    model::ACTIONS.map do |action|
      [model.t("action.#{action}"), action]
    end
  end

  def customer_vault_event_contact_types_for_filter_select
    model = Dorsale::CustomerVault::Event
    model::CONTACT_TYPES.map do |contact_type|
      [model.t("contact_type.#{contact_type}"), contact_type]
    end
  end

  def new_event_for(person)
    policy_scope(Dorsale::CustomerVault::Event).new(person: person, author: current_user)
  end

  def customer_vault_tag_list
    Dorsale::TagListForModel.(Dorsale::CustomerVault::Person)
  end

  def customer_vault_origins_for_select
    policy_scope(Dorsale::CustomerVault::Origin)
  end

  def customer_vault_activity_types_for_select
    policy_scope(Dorsale::CustomerVault::ActivityType)
  end
end
