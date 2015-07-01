module Dorsale
  module FormHelper
    def form_buttons(opts = {})
     back_url = opts[:back_url]
     back_url = url_for(:back).html_safe if back_url.nil?

      if opts[:obj].present?
        if opts[:obj].new_record?
          submit_action = :create
        else
          submit_action = :update
        end
      else
        submit_action = :save
      end

      content_tag("div", class: "actions cdiv") do
        submit = content_tag(:button, type: :submit, class: "btn btn-sm btn-success") do
          icon(:save) + " " + t("actions.#{submit_action}")
        end

        cancel = content_tag("a", href: back_url, class: "btn btn-primary btn-sm") do
          icon(:times) + " " + t("actions.cancel")
        end

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

    def search_form(opts = {})
      action = opts.delete(:action) || request.fullpath

      render "dorsale/search/form", action: action
    end

  end
end
