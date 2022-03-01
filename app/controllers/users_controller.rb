class UsersController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
    
    def create
        # salt = BCrypt::Engine::generate_salt
        user = User.new user_params
        # user.password = BCrypt::Engine::hash_secret user.password, salt
        user.save!

        session[:user_id] = user.id
        render json: user, status: 200
    end

    def show
        user = User.find_by id: session[:user_id]
        if user
            render json: user, status: 200
        else
            render json: {error: 'Unauthorized'}, status: 401
        end
    end

    private
  
    def invalid_record invalid
        render json: {error: 'Invalid record'}, status: 422
    end

    def user_params
        params.permit :username, :password, :password_confirmation
    end
    
end
