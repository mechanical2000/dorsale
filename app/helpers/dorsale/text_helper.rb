module Dorsale
  module TextHelper
    include ::ActionView::Helpers::TextHelper
    include ::ActionView::Helpers::SanitizeHelper

    def euros(n)
      return if n.nil?

      number(n) + " €"
    end

    def percentage(n)
      return if n.nil?

      number(n) + " %"
    end

    def number(n)
      return if n.nil?

      opts = {}

      if n.class.to_s.match(/Float|Decimal/i)
        opts[:precision] = 2
      else
        opts[:precision] = 0
      end

      opts[:delimiter] = I18n.t("number.format.delimiter")
      opts[:separator] = I18n.t("number.format.separator")

      number_with_precision(n, opts)
    end

    def date(d)
      return if d.nil?
      I18n.l(d)
    end

    def hours(n)
      return if n.nil?

      number = number_with_precision(n, precision: 2)
      text   = I18n.t("datetime.prompts.hour").downcase
      text   = text.pluralize if n > 1
      "#{number} #{text}"
    end

    def text2html(str)
      return if str.to_s.blank?

      str = str.gsub("\r", "").strip
      strip_tags(str).gsub("\n", "<br />").html_safe
    end

    def info(object, attribute, text = nil)
      label = content_tag(:strong) do
        object.t(attribute)
      end

      span_css_class = "#{object.class.model_name.element}-#{attribute}"

      value = content_tag(:span, class: span_css_class) do
        text || object.send(attribute)
      end

      content_tag(:div, class: "info") do
        "#{label} : #{value}".html_safe
      end
    end
  end
end
