module Dorsale
  module LinkHelper
    def icon_link_to(icon, name, options = nil, html_options = nil, &block)
      name = "#{icon(icon)} #{name}"
      link_to(name, options, html_options, &block).html_safe
    end

    def web_link(text, opts = {})
      return if text.to_s.blank?

      href = text
      href = "http://#{text}" unless text.include?("://")

      link_to(text, href, opts).html_safe
    end

    def email_link(text, opts = {})
      return if text.to_s.blank?

      href = "mailto:#{text}"

      link_to(text, href, opts).html_safe
    end

    def tel_link(text, opts = {})
      return if text.to_s.blank?

      value = text.gsub(" ", "")
      href  = "tel:#{value}"

      link_to(text, href, opts).html_safe
    end

    def twitter_link(text, opts = {})
      return if text.to_s.blank?

      href = text
      href = "https://twitter.com/#{text}" unless text.include?("twitter.com")
      href = "https://#{text}" unless href.include?("://")

      link_to(text, href, opts).html_safe
    end

  end
end
