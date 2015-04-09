module Dorsale
  module TextHelper
    def euros(n)
      number_to_currency(n)
    end

    def percentage(n)
      number_to_percentage(n, precision: 2, format: "%n %")
    end

    def text2html(str)
      h(str).gsub("\r", "").gsub("\n", "<br />").html_safe
    end
  end
end
