module Dorsale
  module SmallData
    class FiltersController < ApplicationController

      def create
        filters = params[:filters] || {}

        filters.each do |key, value|
          filters[key] = "" if value == "0"
        end

        Filter.new(cookies).store(filters)

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
