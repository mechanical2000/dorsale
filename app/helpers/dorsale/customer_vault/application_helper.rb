module Dorsale
  module CustomerVault
    module ApplicationHelper
      def customer_vault_breadcrumb
        breadcrumb = []

        breadcrumb << link_to(icon(:home), "/")

        breadcrumb << link_to(t("customer_vault"), dorsale.customer_vault_people_path)

        person = @person || @individual || @corporation
        breadcrumb << link_to(person.name, person) if person.present? && person.persisted?

        if params[:controller].to_s.include?("links")
          breadcrumb << ::Dorsale::CustomerVault::Link.t.pluralize
          breadcrumb << @link.title if @link.try(:title).present?
        end

        # Add action
        action      = params[:action]
        action_name = t("actions.#{action}")
        breadcrumb << action_name unless action == "show"

        # Last element is not a link
        breadcrumb << strip_tags(breadcrumb.pop)

        breadcrumb
      end

      def person_tags(person)
        return if person.tag_list.empty?

        person.tag_list.map { |tag|
          content_tag(:span, class: "tag label label-primary"){
            "#{icon :tag} #{tag}".html_safe
          }
        }.join(" ").html_safe
      end



      # Routes fix

      def customer_vault_corporation_customer_vault_link_path(person, link)
        dorsale.url_for(
          :controller     => "dorsale/customer_vault/links",
          :action         => "show",
          :corporation_id => person.id,
          :id             => link.id,
        )
      end

      def edit_customer_vault_corporation_customer_vault_link_path(person, link)
        dorsale.url_for(
          :controller     => "dorsale/customer_vault/links",
          :action         => "edit",
          :corporation_id => person.id,
          :id             => link.id,
        )
      end

      def customer_vault_individual_customer_vault_link_path(person, link)
        dorsale.url_for(
          :controller     => "dorsale/customer_vault/links",
          :action         => "show",
          :corporation_id => person.id,
          :id             => link.id,
        )
      end

      def edit_customer_vault_individual_customer_vault_link_path(person, link)
        dorsale.url_for(
          :controller     => "dorsale/customer_vault/links",
          :action         => "edit",
          :corporation_id => person.id,
          :id             => link.id,
        )
      end

      def customer_vault_individual_customer_vault_links_path(person)
        dorsale.url_for(
          :controller     => "dorsale/customer_vault/links",
          :action         => "create",
          :id => person.id,
        )
      end

      def customer_vault_corporation_customer_vault_links_path(person)
        dorsale.url_for(
          :controller     => "dorsale/customer_vault/links",
          :action         => "create",
          :id => person.id,
        )
      end

    end
  end
end
