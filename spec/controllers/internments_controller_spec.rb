# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InternmentsController, type: :controller do
  context 'Get internments#index' do
    before(:each) do
      @clinic = FactoryBot.create(:clinic)
      @patient = FactoryBot.create(:patient, clinic: @clinic)
    end
    it 'Returns a success response' do
      get :index, params: { clinic_id: @clinic.id, patient_id: @patient.id }
      expect(response).to have_http_status(:success)
    end
    it 'Responds to JSON' do
      get :index, format: :json, params: { clinic_id: @clinic.id, patient_id: @patient.id }
      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end
  end
  context 'Get internments#show' do
    let!(:internment) { create :internment }
    it 'Render JSON' do
      get :show, params: { id: internment.id }
      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end
  end
end
