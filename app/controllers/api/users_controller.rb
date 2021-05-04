class Api::UsersController < ApplicationController
  before_action :find_user, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :updateImageUrl, :destroy]

  def userBySessionToken
    @user = current_user
    if @user
      render :show
    else
      render json: ""
    end
  end
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      render :show
    else
      render json: @user.errors.full_messages, status: 401
    end
  end
  
  def update
    if @user && @user.update_attributes(user_params)
      render :show
    elsif !@user
      render json: ['Could not locate user'], status: 400
    else
      render json: @user.errors.full_messages, status: 401
    end
  end
  
  def destroy
    if @user
      @user.destroy
      render :show
    else
      render ['Could not find user']
    end
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
