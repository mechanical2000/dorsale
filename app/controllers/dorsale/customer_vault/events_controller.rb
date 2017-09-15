class Dorsale::CustomerVault::EventsController < ::Dorsale::CustomerVault::ApplicationController
  def index
    authorize model, :list?

    @events ||= scope.all

    @filters ||= ::Dorsale::CustomerVault::SmallData::FilterForEvents.new(filters_jar)
    @events = @filters.apply(@events)

    @events = @events.page(params[:page]).per(50)
  end

  private

  def model
    Dorsale::CustomerVault::Event
  end
end
