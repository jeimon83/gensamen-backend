# frozen_string_literal: true

# Contacts Controller
class ContactsController < ApplicationController
  before_action :set_patient, only: [:index, :new, :create]
  before_action :set_contact, only: [:show, :update, :destroy]

  def index
    service = Search::Contact.new(current_user, @patient, params)
    service.run
    contacts = service.data.map { |c| { id: c.id, name: c.firstname, lastname: c.lastname, document_type: c.document_type,
                                        document_number: c.document_number, relationship: c.relationship, phone: c.phone, 
                                        patient_id: c.patient_id } }
    render json: { contacts: contacts, meta: service.metadata }
  end
   
  def create
    @contact = @patient.contacts.new
    if @contact.save
      render json: @contact, serializer: ContactSerializer
    else
      render json: @contact.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    render json: @contact
  end

  def update
    if @contact.update(contact_params)
      render json: @contact, serializer: ContactSerializer
    else
      render json: @contact.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    if @contact.destroyed?
      render json: {}, status: :no_content
    else
      render json: @contact.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:patient_id, :lastname, :firstname, :document_type, :document_number, :relationship, :phone)
  end
end
