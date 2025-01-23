require 'rails_helper'
RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:user, password: "Test@123")}
  let(:profile_pic) { Rack::Test::UploadedFile.new(Rails.root.join('spec/images/image_test.jpg'), 'image/jpeg') }

  describe 'GET #show' do
    context 'when the user exists' do
      it 'returns the user details' do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']['id']).to eq(user.id.to_s)
        expect(json_response['meta']['message']).to eq('User details')
      end
    end

    context 'when the user does not exist' do
      it 'returns a not found error' do
        get :show, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']['message'].join('')).to eq('User not found')
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { FactoryBot.create(:user) }
    context 'Updating user details' do
      let(:valid_params) { { user: { email: user.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, profile_pic: profile_pic }, id: user.id } }

      it 'updates the user' do
        put :update, params: valid_params
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['email']).to eq(user.email)
      end
    end

    context 'when the update fails due to invalid parameters' do
      let(:invalid_params) { { user: { email: user.email, first_name: '', last_name: user.last_name }, id: user.id  } }
      it 'does not update the user and returns errors' do
        put :update, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to include("First name can't be blank")
      end
    end
  end

  describe 'PUT #update_password' do
    context 'when current password is incorrect' do
      let(:incorrect_pass_params) { { user: { current_password: "wrong_password", password: "New@1234", confirm_password: "New@1234" }, id: user.id }}

      it 'returns an error for incorrect current password' do
        put :update_password, params: incorrect_pass_params
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']['message']).to include("Incorrect current password")
      end
    end

    context 'when new password and confirm password do not match' do
      let(:mismatched_params) { {id: user.id,  user: { current_password: "Test@123", password: "New@1234", confirm_password: "Mismatch@1234" }}}

      it 'returns an error for password mismatch' do
        put :update_password, params: mismatched_params
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']['message']).to include("Password and confirm password should be match")
      end
    end

    context 'when new password does not meet validation criteria' do
      let(:invalid_password_params) { {id: user.id, user: {current_password: "Test@123", password: "short", confirm_password: "short" }}}

      it 'returns an error for invalid password format' do
        put :update_password, params: invalid_password_params
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']['message']).to include("Password should contain minimum 6 characters, 1 number, 1 special character.")
      end
    end

    context 'when all parameters are valid' do
      let(:valid_params) { {id: user.id, user: {current_password: "Test@123", password: "Valid@123", confirm_password: "Valid@123" }}}

      it 'updates the password successfully' do
        put :update_password, params: valid_params
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['meta']['message']).to eq("Password updated successfully.")
      end
    end
  end
end