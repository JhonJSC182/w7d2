class UsersController < ApplicationController
    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            log_in(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    def show
        @user = User.find_by(id: params[:id])
        if @user
            redirect_to user_url(@user)
            #render :show
        else
            flash[:errors] = ["Cannot find user"]
            redirect_to new_user_url
        end

    end

    private

    def user_params
        params.require(:user).permit(:email, :password)
    end
end
