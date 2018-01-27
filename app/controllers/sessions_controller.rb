class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # emailがない場合，nilが返る
    if user && user.authenicate(params[:session][:password]) # userがいて，passwordが等しい場合true
      redirect_to
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end

  def destroy

  end
end
