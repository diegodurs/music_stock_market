class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password], params[:remember])
    if @user
      redirect_to root_path, success: 'Logged in!'
    else
      @user = User.new(email: params[:email])
      flash.now[:error] = "Login failed."
      render :new
    end
  end

  # def destroy
  #   logout
  #   redirect_to root_path, notice: 'Logged out!'
  # end
end