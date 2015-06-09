module Dorsale
  module TextHelper
    def euros(n)
      number_to_currency(n)
    end

    def percentage(n)
      number_to_percentage(n, precision: 2, format: "%n %")
    end

    def number(n)
      if n.is_a?(Float)
        number_with_precision(n, precision: 2)
      else
        n.to_s
      end
    end

    def hours(n)
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
