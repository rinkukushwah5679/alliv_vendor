class UsersController < ApplicationController
	before_action :set_user, only: [:show, :update, :update_password]

	def show
		render json: UserSerializer.new(@user, meta: {message: "User details"}).serializable_hash, status: :ok
	end

	def update
		if @user.update(user_params)
			render json: UserSerializer.new(@user, meta: { message: 'User updated successfully.' }), status: :ok
	  else
	    render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
	  end
	end

	def update_password
		return render json: {errors: {message: ["Incorrect current password"]}}, status: :unprocessable_entity unless @user.valid_password?(password_params[:current_password])

		return render json: {errors: {message: ['Password and confirm password should be match']}}, status: :unprocessable_entity if password_params[:password] != password_params[:confirm_password]

    password_valid = PasswordValidation.new(password_params[:password])
    return render json: {errors: {message: ['Password should contain minimum 6 characters, 1 number, 1 special character.']}}, status: :unprocessable_entity unless password_valid.valid?

    if @user.update(password: password_params[:password])
			render json: UserSerializer.new(@user, meta: { message: 'Password updated successfully.' }), status: :ok
	  else
	    render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
	  end
	end

	private
	def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :is_active, :profile_pic)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :confirm_password)
  end

	def set_user
		@user = User.find_by(id: params[:id])
		return render json: {errors: {message: ["User not found"]}}, :status => :not_found unless @user.present?
	end
end
