class SessionsController < ApplicationController

	def new
		
	end


	def create
	  user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
        #Sign in the user and redirect to the user's show page
        sign_in user
        redirect_to user
      else
      	#Create error message and render sign in page
        flash.now[:error] = 'Invalid email/password combination' # Not quite right!
        render 'new'
	  end
	end

    def destroy
	   sign_out
	   redirect_to root_url
    end
end
