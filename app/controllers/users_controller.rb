class UsersController < ApplicationController
  
  # Ensure user must be signed in to index, edit, update, destroy
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  # Ensure while user is signed in, they only edit their information
  before_action :correct_user, only: [:edit, :update]
  # Restict access to destroy to admin only
  before_action :admin_user, only: :destroy


  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome To The Sample App"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
  
  # show action is not protected using before_filter hence it allows 
  # non-signed_in or logged users to view a selected persons profile
  def show
    @user = User.find(params[:id])

    #@microposts = Microposts.all
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    #@users = User.all
    @users = User.paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #Before Filters for Authorization
    
    # This has been moved to SessionHelper for centralized access between
    # UsersController and SessionsController
    # def signed_in_user
    #  unless signed_in?
    #    store_location
    #    flash[:notice] = "Please Sign in to Access the Page."
    #    redirect_to signin_url
    #  end
    # end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) #Define current_user?(user) in SessionsHelper, wasn't there
        redirect_to root_url
      end
    end

    def admin_user
      unless current_user.admin?
        redirect_to root_url
      end
    end
end
