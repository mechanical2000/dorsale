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
        redirect_to dorsale.users_path, notice: t("messages.users.create_ok")
      else
        flash[:error] = t("messages.users.create_error")
        render :new
      end
    end

    def update
      authorize! :update, @user
      if @user.update(user_params)
        redirect_to dorsale.users_path, notice: t("messages.users.update_ok")
      else
        flash[:error] = t("messages.users.update_error")
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