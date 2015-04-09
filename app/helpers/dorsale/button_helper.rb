module Dorsale
  module ButtonHelper
    def dorsale_button(url, options = {})
      action = options.delete(:action)
      icon   = options.delete(:icon)

      text = options.delete(:text) || t("actions.#{action}")
      text = "#{icon icon} #{text}"

      options = {
        :class => "btn btn-xs link_#{action}"
      }.deep_merge(options)

      if confirm = options.delete(:confirm)
        confirm = t("actions.confirm") if confirm == true

        options.deep_merge!(
          :data => {
            :confirm => confirm
          }
        )
      end

      link_to(text, url, options)
    end

    def create_button(url, options = {})
      options = {
        :icon   => :plus,
        :action => :create,
        :class  =>"btn btn-xs btn-success link_create"
      }.merge(options)

      dorsale_button(url, options)
    end

    def read_button(url, options = {})
      options = {
        :icon   => "info-circle",
        :action => :read
      }.merge(options)

      dorsale_button(url, options)
    end

    def update_button(url, options = {})
      options = {
        :icon   => :pencil,
        :action => :update
      }.merge(options)

      dorsale_button(url, options)
    end

    def delete_button(url, options = {})
      options = {
        :icon    => :trash,
        :action  => :delete,
        :class   => "btn btn-xs btn-danger link_delete",
        :confirm => true,
        :method  => :delete,
      }.merge(options)

      dorsale_button(url, options)
    end

    def complete_button(url, options = {})
      options = {
        :icon    => :check,
        :action  => :complete,
        :class   => "btn btn-xs btn-success link_complete",
        :confirm => true,
        :method  => :patch,
      }.merge(options)

      dorsale_button(url, options)
    end

    def snooze_button(url, options = {})
      options = {
        :icon    => :"clock-o",
        :action  => :snooze,
        :confirm => true,
        :method  => :patch
      }.merge(options)

      dorsale_button(url, options)
    end

    def lock_button(url, options = {})
      options = {
        :icon    => :lock,
        :action  => :lock,
        :confirm => true,
        :method  => :patch
      }.merge(options)

      dorsale_button(url, options)
    end

    def unlock_button(url, options = {})
      options = {
        :icon    => :unlock,
        :action  => :unlock,
        :confirm => true,
        :method  => :patch
      }.merge(options)

      dorsale_button(url, options)
    end

    def filter_submit_button(options = {})
      options[:class] ||= "btn"
      options[:type]  ||= "submit"

      text = options.delete(:text) || t("actions.filter")
      icon = options.delete(:icon) || "filter"

      content_tag(:button, options) do
        icon(icon) + " " + text
      end
    end

    def filter_reset_button(options = {})
      options[:class] ||= "btn reset"
      options[:type]  ||= "submit"

      text = options.delete(:text) || t("actions.reset")
      icon = options.delete(:icon) || "rotate-left"

      content_tag(:button, options) do
        icon(icon) + " " + text
      end
    end

  end
end
