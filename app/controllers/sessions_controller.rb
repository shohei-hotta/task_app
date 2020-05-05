class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to tasks_url, success: "#{t("view.flash.login_message")}"
    else
      flash.now[:danger] = "#{t("view.flash.login_alert")}"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to new_session_url, success: "#{t("view.flash.logout_message")}"
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
