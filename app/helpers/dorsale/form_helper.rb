module Dorsale
  module FormHelper
    def form_buttons(opts = {})
     back_url = opts[:back_url]
     back_url = url_for(:back).html_safe if back_url.nil?

      content_tag("div", class: "actions cdiv") do
        submit = tag("input", type: "submit", class: "btn btn-success btn-sm", value: "Valider", id: "submit")
        cancel = content_tag("a", href: back_url, class: "btn btn-primary btn-sm"){ "Annuler" }
        cancel = "" if back_url == false
        submit + cancel
      end
    end

    def horizontal_form_for(obj, opts={}, &block)
      opts = {
        :wrapper => "horizontal_form",
        :html => {
          :class => "form-horizontal"
        }
      }.deep_merge(opts)

      simple_form_for(obj, opts, &block)
    end
  end
end
