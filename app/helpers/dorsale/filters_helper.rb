module Dorsale
  module FiltersHelper
    def filter_submit_button(options = {})
      options[:class] ||= "btn submit filter-submit"
      options[:type]  ||= "submit"

      text = options.delete(:text) || t("actions.filter")
      icon = options.delete(:icon) || "filter"

      content_tag(:button, options) do
        icon(icon) + " " + text
      end
    end

    def filter_reset_button(options = {})
      options[:class] ||= "btn reset filter-reset"
      options[:type]  ||= "submit"

      text = options.delete(:text) || t("actions.reset")
      icon = options.delete(:icon) || "rotate-left"

      content_tag(:button, options) do
        icon(icon) + " " + text
      end
    end
  end
end
