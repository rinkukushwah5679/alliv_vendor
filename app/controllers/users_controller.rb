class UsersController < ApplicationController
	before_action :set_user#, only: [:show, :update, :update_password, :create_addresse]

	def show
		render json: UserSerializer.new(@user, meta: {message: "User details"}).serializable_hash, status: :ok
	end

	def update
		if @user.update(user_params)
			update_emergency_contact if params.dig(:user, :emergency_contact).present?
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

	def business_details
		render json: BusinessDetailsSerializer.new(@user.business_detail, meta: {message: "Business details"}).serializable_hash, status: :ok
	end

	def update_business_details
		business = BusinessDetail.find_or_initialize_by(user_id: @user.id)
	  business.created_by = @user.id if business.new_record?
	  business.updated_by = @user.id
	  if business.update(business_params)
			render json: BusinessDetailsSerializer.new(business, meta: {message: "Business updated successfully."}).serializable_hash, status: :ok
	  else
			render json: { errors: business.errors.full_messages }, status: :unprocessable_entity
	  end
	end

	private
	def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :unit_nickname, :gender, :dob, :is_active, :profile_pic)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :confirm_password)
  end

  def business_params
		params.require(:business_detail).permit(:busi_name, :first_name, :last_name, :office_address, :phone, :email, :fein_or_tin_number, :business_logo)
  end

	def set_user
		@user = User.find_by(id: params[:id])
		return render json: {errors: {message: ["User not found"]}}, :status => :not_found unless @user.present?
	end

	def update_emergency_contact
	  emergency_con = EmergencyContact.find_or_initialize_by(user_id: @user.id)
	  emergency_con.created_by = @user.id if emergency_con.new_record?
	  emergency_con.updated_by = @user.id
	  emergency_con.update(params.require(:user).require(:emergency_contact).permit(:phone_number, :name, :email, :relationship))
	end
end
