class SessionsController < ApplicationController
  
  def new
    redirect_to root_path unless session[:user_id].nil?
  end

  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:notice] = "Username or password is invalid"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
