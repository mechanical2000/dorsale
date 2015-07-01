module Dorsale
  module CustomerVault
    class PeopleController < ::Dorsale::CustomerVault::ApplicationController
      handles_sortable_columns

      def index
        redirect_to dorsale.customer_vault_people_activity_path
      end

      def list
        authorize! :list, Person

        @filters      ||= ::Dorsale::CustomerVault::SmallData::FilterForPeople.new(cookies)
        @tags         ||= customer_vault_tag_list
        @individuals  ||= ::Dorsale::CustomerVault::Individual.search(params[:q])
        @corporations ||= ::Dorsale::CustomerVault::Corporation.search(params[:q])

        if params[:q].blank?
          @individuals  = @filters.apply(@individuals)
          @corporations = @filters.apply(@corporations)
        end

        @people ||= @individuals + @corporations

        @people = @people.sort_by(&:name)

        @people = Kaminari.paginate_array(@people).page(params[:page]).per(25)
      end

      def activity
        authorize! :list, Person

        @comments ||= Dorsale::Comment
          .where("commentable_type LIKE ?", "%CustomerVault%")
          .order("created_at DESC, id DESC")

        @comments = @comments.page(params[:page]).per(50)
      end

    end
  end
end
