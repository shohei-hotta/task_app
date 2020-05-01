class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_url(@user.id), success: "「#{@user.name}」#{t("view.flash.create_message")}"
    else
      flash:now[:danger] = "#{t("view.flash.create_alert")}"
      render :new
    end
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_digest)
  end
end
