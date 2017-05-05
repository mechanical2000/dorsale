class Dorsale::CustomerVault::PeopleController < ::Dorsale::CustomerVault::ApplicationController
  before_action :set_objects

  def index
    authorize model, :list?

    @filters        ||= ::Dorsale::CustomerVault::SmallData::FilterForPeople.new(cookies)
    @tags           ||= customer_vault_tag_list
    @origins        ||= policy_scope(Dorsale::CustomerVault::Origin)
    @activity_types ||= policy_scope(Dorsale::CustomerVault::ActivityType)
    @people         ||= policy_scope(model)
      .search(params[:q])
      .preload(:taggings)

    if params[:q].blank?
      @people = @filters.apply(@people)
    end

    @people_without_pagination = @people

    @people = @people.page(params[:page]).per(25)
  end

  def corporations
    index
    render :index
  end

  def individuals
    index
    render :index
  end

  def activity
    authorize model, :list?

    @events ||= policy_scope(::Dorsale::CustomerVault::Event)

    @events = @events.page(params[:page]).per(50)
  end

  def new
    authorize model, :create?

    if model == Dorsale::CustomerVault::Person
      skip_policy_scope
      redirect_to url_for(action: :index)
      return
    end

    @person ||= scope.new

    @person.build_address if @person.address.nil?
  end

  def create
    authorize model, :create?

    @person ||= scope.new(person_params_for_create)

    if @person.save
      generate_event!("create")
      flash[:notice] = t("messages.#{person_type.to_s.pluralize}.create_ok")
      redirect_to back_url
    else
      render :new
    end
  end

  def show
    authorize @person, :read?
  end

  def tasks
    show
  end

  def invoices
    show
  end

  def edit
    authorize @person, :update?

    @person.build_address if @person.address.nil?
  end

  def update
    authorize @person, :update?

    if @person.update(person_params_for_update)
      generate_event!("update")
      flash[:notice] = t("messages.#{person_type.to_s.pluralize}.update_ok")
      redirect_to back_url
    else
      render :edit
    end
  end

  def destroy
    authorize @person, :delete?

    if @person.destroy
      flash[:notice] = t("messages.#{person_type.to_s.pluralize}.delete_ok")
    else
      flash[:alert] = t("messages.#{person_type.to_s.pluralize}.delete_error")
    end

    redirect_to customer_vault_people_path
  end

  private

  def back_url
    if @person
      url_for(action: :show, id: @person)
    else
      url_for(action: :index, id: nil)
    end
  end

  def model
    # New / Create / Individuals / Corporations
    return ::Dorsale::CustomerVault::Corporation if request.path.include?("/corporations")
    return ::Dorsale::CustomerVault::Individual  if request.path.include?("/individuals")

    # Other member actions
    return ::Dorsale::CustomerVault::Corporation if @person.try(:person_type) == :corporation
    return ::Dorsale::CustomerVault::Individual  if @person.try(:person_type) == :individual

    # Collection actions
    return ::Dorsale::CustomerVault::Person
  end

  def person_type
    model.to_s.demodulize.downcase.to_sym
  end

  def set_objects
    @person ||= scope.find(params[:id]) if params.key?(:id)
  end

  def common_permitted_params
    [
      :short_name,
      :avatar,
      :email,
      :phone,
      :mobile,
      :fax,
      :skype,
      :www,
      :twitter,
      :facebook,
      :linkedin,
      :viadeo,
      :context,
      :origin_id,
      :activity_type_id,
      :tag_list => [],
      :address_attributes => [
        :street,
        :street_bis,
        :zip,
        :city,
        :country
      ],
    ]
  end

  def permitted_params_for_corporations
    common_permitted_params + [
      :corporation_name,
      :capital,
      :immatriculation_number,
      :european_union_vat_number,
      :legal_form,
      :revenue,
      :societe_com,
      :number_of_employees,
    ]
  end

  def permitted_params_for_individuals
    common_permitted_params + [
      :corporation_id,
      :first_name,
      :last_name,
      :title,
    ]
  end

  def permitted_params
    return permitted_params_for_corporations if person_type == :corporation
    return permitted_params_for_individuals  if person_type == :individual
    return []
  end

  def person_params
    params.fetch(:person, {}).permit(permitted_params)
  end

  def person_params_for_create
    person_params
  end

  def person_params_for_update
    person_params
  end

  def generate_event!(action)
    policy_scope(::Dorsale::CustomerVault::Event).create!(
      :author => current_user,
      :person => @person,
      :action => action,
    )
  end

end
