class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :show]
  before_action :login_required
  before_action :admin_required

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_url, success: "「#{@user.name}」#{t("view.flash.create_message")}"
    else
      flash.now[:danger] = "#{t("view.flash.create_alert")}"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_url, success: "「#{@user.name}」#{t("view.flash.edit_message")}"
    else
      flash.now[:danger] = "#{t("view.flash.edit_alert")}"
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, success: "「#{@user.name}」#{t("view.flash.destroy_message")}"
  end

  def index
    @users = User.select(:id, :name, :email, :created_at).includes(:tasks)
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def login_required
    redirect_to new_session_url, danger: "#{t("view.flash.require_login_alert")}" unless logged_in?
  end

  def admin_required
    redirect_to tasks_url, danger: "#{t("view.flash.require_admin_alert")}" unless current_user.admin
  end
end
