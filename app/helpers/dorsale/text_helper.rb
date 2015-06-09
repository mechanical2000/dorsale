module Dorsale
  module TextHelper
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

      if n.class.to_s.match(/Float|Decimal/i)
        number_with_precision(n, precision: 2)
      else
        n.to_s
      end
    end

    def hours(n)
      return if n.nil?

      number = number_with_precision(n, precision: 2)
      text   = I18n.t("datetime.prompts.hour").downcase
      text   = text.pluralize if n > 1
      "#{number} #{text}"
    end

    def text2html(str)
      h(str).gsub("\r", "").gsub("\n", "<br />").html_safe
    end
  end
end
