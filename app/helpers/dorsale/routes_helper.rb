module Dorsale
  module RoutesHelper
    def engine_polymorphic_path(obj, opts = {})
      if obj.class.parent == Object
        routes = main_app
      else
        routes = obj.class.parent::Engine.routes
      end

      opts = {
        :controller => "/#{obj.class.to_s.tableize}",
        :action     => :show,
        :id         => obj.to_param,
        :only_path  => true
      }.merge(opts)

      routes.url_for(opts)
    end
  end
end
