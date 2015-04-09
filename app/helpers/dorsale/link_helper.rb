module Dorsale
  module LinkHelper
    def icon_link_to(icon, name, options = nil, html_options = nil, &block)
      name = "#{icon(icon)} #{name}"
      link_to(name, options, html_options, &block)
    end

  end
end
