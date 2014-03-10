class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

	def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def destroy
    user = User.find(params[:id])
    user_name = user.name
    unless current_user?(user)
      if user.destroy 
        flash[:success] = t("users.flash.destroyed", user_name: user_name)
      end
    end
    redirect_to users_url
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t("users.flash.updated", user_name: @user.name)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = t("users.flash.created", user_name: @user.name)    	
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: t("users.flash.sign_in")
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
