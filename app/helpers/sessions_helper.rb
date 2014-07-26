module SessionsHelper

  # REMEMBER:
  # 1. When signed_in, user becomes current_user
  # 2. When signed_out, current_user becomes user
  def sign_in(user)
    # 1.Create new token
    remember_token = User.new_remember_token
    # 2.Place new token in broswer cookies
    cookies.permanent[:remember_token] = remember_token
    # 3.Save hashed token to the database
    user.update_attribute(:remember_token, User.digest(remember_token))
    # 4.Set current user equal to give user
    self.current_user = user
  end

  def signed_in?
    #user is signed_in if current_user in the session is not equal to nil
    !current_user.nil?
  end
  
  def current_user=(user)
  	@current_user = user
  end

  def current_user
    # Find user corresponding to remember_token created in sign_in method above
    # Use token from the browser, hash it, and check that it matches the
    # database one
    # Then use it to find user in the database
    remember_token = User.digest(cookies[:remember_token])
    @current_user  = @current_user || User.find_by(remember_token: remember_token)
  end
  
  def sign_out
    # Change or Create new remember_token in the database
    current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    # Delete cookies to remove remember_token from session
    cookies.delete(:remember_token)
    # Set current_user to nil
    self.current_user  = nil
  end
  

  # ADDED TO HANDLE correct_user before-action IN users_controllers
  def current_user?(user) 
    user == current_user
  end

  #FRIENDLY FORWARDING
  # 1. Store location of intended page somewhere
  def store_location
    session[:return_to] = request.url if request.get?
  end

  # 2. The redirect to that location instead
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  
  def signed_in_user
    unless signed_in?
      store_location
      flash[:notice] = "Please Sign in to Access the Page."
      redirect_to signin_url
    end
  end
  
end
