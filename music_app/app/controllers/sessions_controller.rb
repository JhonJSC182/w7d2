class SessionsController < ApplicationController
    def new
        @user = User.new
        render :new
    end

    def create
        email = params[:user][:email]
        password = params[:user][:password]
        @user = User.find_by_credentials(email, password)
        if @user
            log_in(@user)
            redirect_to user_url(@user)
        else
            redirect_to new_user_url
            flash[:error] = ["try again :p"]
        end
    end

    def destroy
        log_out
        redirect_to new_session_url
    end
    
end
