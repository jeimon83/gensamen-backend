# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PatientsController, type: :controller do
  let!(:clinic) { FactoryBot.create(:clinic) }
  let!(:other_clinic) { FactoryBot.create(:clinic) }
  let!(:patient) { FactoryBot.create(:patient) }
  let!(:admin_user) { FactoryBot.create(:user, :admin) }
  let!(:common_user) { FactoryBot.create(:user, clinic_id: other_clinic.id) }
  
  describe 'GET #index' do
    context 'when user is admim' do   
      it 'returns a success response' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(admin_user)
        get :index, params: { clinic_id: clinic.id }
        expect(response).to have_http_status(:success)
      end
    end
    context 'when user is from other clinic' do
      it 'returns a failure response' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(common_user)
        get :index, params: { clinic_id: clinic.id }
        expect(response).to have_http_status(401)
      end
    end
    context 'format view' do
      it 'responds to json' do
        get :index, format: :json, params: { clinic_id: clinic.id }
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end
  end

  describe 'GET #show' do
    context 'when user is admin' do
      it 'renders the patient' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(admin_user)
        get :show, params: { id: patient.id }
        expect(response.body['patient']).to be_present
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end
    context 'when user is from other clinic' do
      it 'renders error: not authorized' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(common_user)
        get :show, params: { id: patient.id }
        expect(response.body).to match("Not Authorized")
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is admin' do
      it 'updates the patient' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(admin_user)
        patch :update, params: { id: patient.id, patient: { firstname: 'Juan' } }
        expect(response.body['patient']).to be_present
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is admin' do
      it 'destroys the patient' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(admin_user)
        expect { delete :destroy, params: { id: patient }}.to change { Patient.count }.by(-1)
      end
    end
    context 'when user is from other clinic' do
      it 'renders error: not authorized' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(common_user)
        delete :destroy, params: { id: patient.id }
        expect(response.body).to match("Not Authorized")
      end
    end
  end
end

RSpec.describe PatientsController, type: :request do
  let!(:clinic) { FactoryBot.create(:clinic) }
  let!(:patient) { FactoryBot.create(:patient) }
  let!(:admin_user) { FactoryBot.create(:user, :admin) }
  let!(:common_user) { FactoryBot.create(:user, clinic_id: clinic.id) }

  describe 'Endpoint GET #index' do
    context 'when user is not admin' do
      it 'returns an http success response' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(common_user)
        get '/clinics'
        expect(response.body['clinic']).to be_present
        expect(response).to have_http_status(:success)
      end
    end
    context 'when authorize api request fails' do
      it 'returns a failure response' do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(nil)
        get '/clinics'
        expect(response).to have_http_status(401)
      end
    end
  end
end
