module Dorsale
  module SmallData
    class FiltersController < ::Dorsale::ApplicationController

      def create
        new_filters = params[:filters] || {}

        new_filters.each do |key, value|
          new_filters[key] = "" if value == "0"
        end

        filters = Filter.new(cookies)
        new_filters = filters.read.merge(new_filters)
        filters.store(new_filters)

        urls = [
          params[:back_url],
          request.referer,
          (main_app.root_path rescue nil)
        ]

        redirect_to urls.select(&:present?).first
      end

    end
  end
end
