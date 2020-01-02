class UsersController < ApplicationController
  
  def new
    if User.count > 0
      redirect_to root_path, notice: "Only one user account can be created at this time."
      return
    end
    
    @user = User.new
  end
  
  def create
    if User.count > 0
      redirect_to root_path, notice: "Only one user account can be created at this time."
      return
    end
    
    @user = User.new user_params
    @user.password = params[:user][:password]
    if @user.password.present? && @user.save
      redirect_to root_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
  end
  
  def delete
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email,:password)
  end
  
end
