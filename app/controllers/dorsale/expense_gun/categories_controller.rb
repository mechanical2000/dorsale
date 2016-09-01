module Dorsale
  module ExpenseGun
    class CategoriesController < ::Dorsale::ExpenseGun::ApplicationController
      def index
        #cancan
        @categories = ::Dorsale::ExpenseGun::Category.all
      end

      def new
        @category = ::Dorsale::ExpenseGun::Category.new
        #cancan
      end

      def create
        @catgory = ::Dorsale::ExpenseGun::Category.new(category_params)
        #cancan
        if @catgory.save
          flash[:notice] = "Category successfully added"
          redirect_to expense_gun_categories_url
        else
          render action: "new"
        end
      end

      def edit
        @category = ::Dorsale::ExpenseGun::Category.find(params[:id])
        #cancan
      end

      def update
        @category = ::Dorsale::ExpenseGun::Category.find(params[:id])
        #cancan
        if @category.update_attributes(category_params)
          redirect_to expense_gun_categories_path, notice: "Category successfully updated"
        else
          render action: "edit"
        end
      end

      private

      def permitted_params
        [
          :name,
          :code,
          :vat_deductible,
        ]
      end

      def category_params
        params.require(:expense_gun_category).permit(permitted_params)
      end
    end
  end
end