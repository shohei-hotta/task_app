class UsersController < ApplicationController
  before_action :login_required, only: [:show]
  before_action :not_your_profile, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_url, success: "「#{@user.name}」#{t("view.flash.create_message")}"
    else
      flash:now[:danger] = "#{t("view.flash.create_alert")}"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_digest)
  end

  def login_required
    redirect_to new_session_url unless logged_in?
  end

  def not_your_profile
    redirect_to tasks_url unless params[:id] == current_user.id.to_s
  end
end
