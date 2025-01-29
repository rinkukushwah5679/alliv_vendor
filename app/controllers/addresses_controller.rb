class AddressesController < ApplicationController
	before_action :set_user
	before_action :set_address, only: [:show, :update, :destroy]

	def index
		render json: AddressSerializer.new(@user.addresses.select("addresses.*, c.email AS c_email, c.id AS c_id, up.email AS up_email, up.id AS up_id").joins("INNER JOIN users as c on c.id = addresses.created_by").joins("INNER JOIN users as up on up.id = addresses.updated_by")), status: :ok
	end

	def show
		render json: AddressSerializer.new(@address), status: :ok
	end

	def create
		return render json: {errors: {message: ["Address type must be Primary or Alternate"]}}, status: :unprocessable_entity unless Address.address_types.keys.include?(address_params[:address_type])
		@address = @user.addresses.new(address_params)
		if @address.save
			render json: CreatedAddressSerializer.new(@address, meta: { message: 'Address created successfully' }), status: :ok
		else
			render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def update
		return render json: {errors: {message: ["Address type must be Primary or Alternate"]}}, status: :unprocessable_entity unless Address.address_types.keys.include?(address_params[:address_type])
		if @address.update(address_params)
			render json: CreatedAddressSerializer.new(@address, meta: { message: 'Address updated successfully' }), status: :ok
		else
			render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def destroy
		@address.destroy
    render json: {message:"Address successfully destroyed."}, status: :ok
	end

	private
	def set_user
		@user = User.find_by(id: params[:user_id])
		return render json: {errors: {message: ["User not found"]}}, :status => :not_found unless @user.present?
	end

	def set_address
		@address = @user.addresses.select('addresses.*, c.email AS c_email, c.id AS c_id, up.email AS up_email, up.id AS up_id').joins('INNER JOIN users as c on c.id = addresses.created_by').joins('INNER JOIN users as up on up.id = addresses.updated_by').find_by_id(params[:id])
		return render json: {errors: {message: ["Address not found"]}}, :status => :not_found unless @address.present?
	end

	def address_params
  	params.require(:address).permit(:address_line1, :address_line2, :address_line3, :city, :state, :postal_code, :country, :address_type, :created_by, :updated_by)
  end
end