class UsersController < ApplicationController
  def register
    existing_user = User.find_by(email: params[:email])
    if existing_user.present?
      return render json: { message: "User already exist with email - #{existing_user.email}." }, status: :unprocessable_entity
    end
    if params[:password].present? && params[:password].length < 8
      return render json: { message: "Password must be at least 8 characters long." }, status: :unprocessable_entity
    end
    user = User.new(user_params)
    if user.save
      render json: { message: 'User registered successfully' }, status: :created
    else
      render json: { message: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, message: 'Login successful.' }
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone, :status, :password, :password_confirmation)
  end
end