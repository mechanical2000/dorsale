class Dorsale::CustomerVault::PeopleController < ::Dorsale::CustomerVault::ApplicationController
  handles_sortable_columns

  def index
    skip_authorization

    redirect_to dorsale.customer_vault_people_activity_path
  end

  def list
    authorize model, :list?

    @total_contact = current_user_scope.people

    @filters      ||= ::Dorsale::CustomerVault::SmallData::FilterForPeople.new(cookies)
    @tags         ||= customer_vault_tag_list
    @individuals  ||= current_user_scope.individuals.search(params[:q])
    @corporations ||= current_user_scope.corporations.search(params[:q])

    if params[:q].blank?
      @individuals  = @filters.apply(@individuals)
      @corporations = @filters.apply(@corporations)
    end

    @people ||= @individuals + @corporations
    @people = @people.sort_by(&:name)

    @people_without_pagination = @people

    @people = Kaminari.paginate_array(@people).page(params[:page]).per(25)
  end

  def activity
    authorize model, :list?

    @people ||= current_user_scope.individuals + current_user_scope.corporations
    @comments ||= current_user_scope.comments
      .where("commentable_type LIKE ?", "%CustomerVault%")
      .order("created_at DESC, id DESC")

    @comments = @comments.page(params[:page]).per(50)
  end

  private

  def model
    ::Dorsale::CustomerVault::Person
  end

end
