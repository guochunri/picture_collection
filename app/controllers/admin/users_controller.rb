class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :find_user, only: [:edit, :update, :destroy]
  layout "admin"

  def index
    @users = User.recent.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  protected

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :role)
  end

end
