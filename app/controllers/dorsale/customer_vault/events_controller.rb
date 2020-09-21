class Dorsale::CustomerVault::EventsController < ::Dorsale::CustomerVault::ApplicationController
  before_action :set_objects

  def index
    authorize model, :list?

    @events ||= scope.all

    @filters ||= ::Dorsale::CustomerVault::SmallData::FilterForEvents.new(filters_jar)
    @events = @filters.apply(@events)

    @events = @events.page(params[:page]).per(50)
  end

  def create
    @event ||= scope.new(event_params_for_create)

    authorize @event, :create?

    if @event.save
      render_event
    else
      render_nothing
    end
  end

  def edit
    authorize @event, :update?
  end

  def update
    authorize @event, :update?

    if @event.update(event_params_for_update)
      render_event
    else
      render_form
    end
  end

  def destroy
    authorize @event, :delete?

    @event.destroy!

    render_nothing
  end

  private

  def model
    Dorsale::CustomerVault::Event
  end

  def set_objects
    @event = scope.find(params[:id]) if params.key?(:id)
  end

  def render_event
    render partial: "event", locals: {event: @event}
  end

  def render_form
    render partial: "form", locals: {event: @event}
  end

  def render_nothing
    head :ok
  end

  def permitted_params
    safe_params = [
      :action,
      :title,
      :contact_type,
      :date,
      :text,
    ]

    if params[:action] == "create"
      safe_params << :person_id
    end

    safe_params
  end

  def common_event_params
    params.fetch(:event, {}).permit(permitted_params)
  end

  def event_params_for_create
    common_event_params.merge(author: current_user)
  end

  def event_params_for_update
    common_event_params
  end
end
