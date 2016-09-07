class Dorsale::UsersController < ::Dorsale::ApplicationController
  before_action :set_user, only: [
    :show,
    :edit,
    :update,
  ]

  def show
  end

  def index
    authorize! :list, User

    @users ||= User.all
  end

  def new
    @user ||= User.new

    authorize! :create, @user
  end

  def edit
    authorize! :update, @user
  end

  def create
    @user ||= User.new(user_params)

    authorize! :create, @user

    if @user.save
      flash[:notice] = t("messages.users.create_ok")
      redirect_to dorsale.users_path
    else
      flash.now[:error] = t("messages.users.create_error")
      render :new
    end
  end

  def update
    authorize! :update, @user

    if @user.update(user_params)
      flash[:notice] = t("messages.users.update_ok")
      redirect_to dorsale.users_path
    else
      flash.now[:error] = t("messages.users.update_error")
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
      :avatar,
    ]
  end

  def user_params
    params.fetch(:user, {}).permit(permitted_params)
  end

end
