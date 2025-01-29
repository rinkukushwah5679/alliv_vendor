require 'rails_helper'
RSpec.describe AddressesController, type: :controller do
  before(:all) do
    @user = create(:user)
    @address = create(:address, addressable: @user, created_by: @user.id, updated_by: @user.id)
  end

  describe "Get#index" do
    it 'returns a list of addresses for the user' do
      get :index, params: {user_id: @user.id}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key("data")
    end
  end

  describe "GET #show" do
    context "when address exists" do
      it "returns the address details" do
        get :show, params: { user_id: @user.id, id: @address.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key("data")
      end
    end

    context "when address does not exist" do
      it "returns an error message" do
        get :show, params: { user_id: @user.id, id: "0" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["errors"]["message"]).to include("Address not found")
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new address" do
        post :create, params: { user_id: @user.id, address: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["meta"]["message"]).to eq("Address created successfully")
      end
    end

    context "with invalid address type attributes" do
      it "does not create a new address and returns an error" do
        post :create, params: { user_id: @user.id, address: invalid_address_type_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]["message"]).to include("Address type must be Primary or Alternate")
      end
    end

    context "with invalid attributes" do
      it "does not create a new address and returns an error for address_line1" do
        post :create, params: { user_id: @user.id, address: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors'].join("")).to include("Address line1 can't be blank")
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "updates the address" do
        put :update, params: { user_id: @user.id, id: @address.id, address: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["meta"]["message"]).to eq("Address updated successfully")
        expect(@address.reload.address_line1).to eq("123 Street")
      end
    end

    context "with invalid attributes" do
      it "does not update the address and returns an error" do
        put :update, params: { user_id: @user.id, id: @address.id, address: { address_type: "InvalidType" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]["message"]).to include("Address type must be Primary or Alternate")
      end
    end

    context "when address does not exist" do
      it "returns an error message" do
        put :update, params: { user_id: @user.id, id: 9999, address: valid_attributes }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["errors"]["message"]).to include("Address not found")
      end
    end

    context "with invalid attributes" do
      it "does not update address and returns an error for address_line1" do
        post :update, params: { user_id: @user.id, id: @address.id, address: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors'].join("")).to include("Address line1 can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when address exists" do
      it "deletes the address and returns success message" do
        delete :destroy, params: { user_id: @user.id, id: @address.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Address successfully destroyed.")
      end
    end
  end

  private
  def valid_attributes
    { address_line1: "123 Street", address_line2: "Apt 456", city: "CityName", state: "StateName", postal_code: "12345", country: "CountryName", address_type: "Primary", created_by: @user.id, updated_by: @user.id }    
  end

  def invalid_address_type_attributes
    { address_line1: "", country: "", address_type: "InvalidType" }
  end

  def invalid_attributes
    { address_line1: "", country: "CountryName", address_type: "Primary", created_by: @user.id, updated_by: @user.id }
  end
end