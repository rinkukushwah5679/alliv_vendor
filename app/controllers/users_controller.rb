class UsersController < ApplicationController
	before_action :set_user, only: [:show, :update]

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

	private
	def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :is_active, :profile_pic)
  end

	def set_user
		@user = User.find_by(id: params[:id])
		return render json: {errors: {message: ["User not found"]}}, :status => :not_found unless @user.present?
	end
end
