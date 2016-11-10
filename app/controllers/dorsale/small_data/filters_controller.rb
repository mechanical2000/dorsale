class Dorsale::SmallData::FiltersController < ::Dorsale::ApplicationController
  def create
    skip_authorization
    skip_policy_scope

    filters = ::Dorsale::SmallData::Filter.new(cookies)
    new_filters = params.fetch(:filters, {}).permit!.to_h
    filters.merge new_filters

    # Rewrite cookie with 1 year expiry
    cookies[:filters] = {
      :value   => cookies[:filters],
      :expires => 1.year.from_now,
      :path    => "/",
    }

    redirect_to back_url
  end

  private

  def back_url
    url = [
      params[:form_url],
      request.referer,
      (main_app.root_path rescue "/"),
    ].select(&:present?).first

    # Delete page param
    base, query_string = url.split("?")
    query_string = query_string.to_s.split("&").delete_if { |p| p.include?("page=") }.join("&")
    query_string = "?#{query_string}" if query_string.present?
    base + query_string
  end

end
