class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # emailがない場合，nilが返る
    if user && user.authenticate(params[:session][:password]) # userがいて，passwordが等しい場合true
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1'? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated."
        message += " Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
