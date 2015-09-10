module Dorsale
  module Flyboy
    class ApplicationController < ::Dorsale::ApplicationController
      handles_sortable_columns

      helper ::Dorsale::CustomerVault::ApplicationHelper
    end
  end
end
