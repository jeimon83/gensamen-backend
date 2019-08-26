# frozen_string_literal: true

# Patients Controller
class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :update, :destroy]

  def index
    service = Search::Patient.new(params)
    service.run
    patients = service.data.map { |patient| { id: patient.id, firstname: patient.firstname, lastnama: patient.lastname, 
        habilitacion: patient.habilitation, beds_voluntary: patient.beds_voluntary, beds_voluntary: patient.beds.beds_voluntary } }
    render json: { clinics: clinics, meta: service.metadata }
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      render json: @patient, serializer: PatientSerializer
    else
      render json: @patient.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    render json: @patient
  end

  def update
    if @patient.update(patient_params)
      render json: @patient, serializer: patientSerializer
    else
      render json: @patient.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    if @patient.destroyed?
      render json: {}, status: :no_content
    else
      render json: @patient.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:lastname, :firstname, :document_type, :document_number, :gender, :birth_date,
                                    :address, :department, :state, :city, :postal_code, :medical_record, :clinic)
  end
end
