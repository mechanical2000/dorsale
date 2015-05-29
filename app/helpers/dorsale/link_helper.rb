module Dorsale
  module LinkHelper
    def icon_link_to(icon, name, options = nil, html_options = nil, &block)
      name = "#{icon(icon)} #{name}"
      link_to(name, options, html_options, &block)
    end

    def web_link(text, opts = {})
      return if text.to_s.blank?

      href = text
      href = "http://#{text}" unless text.include?("://")

      link_to(text, href, opts)
    end

    def email_link(text, opts = {})
      return if text.to_s.blank?

      href = "mailto:#{text}"

      link_to(text, href, opts)
    end

    def tel_link(text, opts = {})
      return if text.to_s.blank?

      href = "tel:#{text}"

      link_to(text, href, opts)
    end

  end
end
