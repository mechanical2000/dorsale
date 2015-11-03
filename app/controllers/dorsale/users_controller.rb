module Dorsale
  class UsersController < ::Dorsale::ApplicationController
    handles_sortable_columns

    before_action :set_user, only: [
      :show,
      :edit,
      :update,
    ]

    def show

    end

    def index
      authorize! :list, User
      @users = User.all
    end

    def new
      @user = User.new
      authorize! :create, @user
    end

    def edit
      authorize! :update, @user
    end

    def create
      @user = User.new(user_params)
      authorize! :create, @user
      if @user.save
        redirect_to dorsale.users_path, notice: t("flash.success.user.created")
      else
        flash[:error] = t("flash.errors.user.created")
        render :new
      end
    end

    def update
      authorize! :update, @user
      if @user.update(user_params)
        redirect_to dorsale.users_path, notice: t("flash.success.user.updated")
      else
        flash[:error] = t("flash.errors.user.updated")
        render :edit
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def permitted_params
      [
      :email,
      :password,
      :password_confirmation,
      :is_active,
      ]
    end

    def user_params
      params.require(:user).permit(permitted_params)
    end
  end
end