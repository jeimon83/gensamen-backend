# frozen_string_literal: true

# == Schema Information
#
# Table name: patients
#
#  id              :bigint           not null, primary key
#  lastname        :string
#  firstname       :string
#  document_type   :string
#  document_number :string
#  gender          :string
#  birth_date      :date
#  address         :string
#  department      :string
#  state           :string
#  city            :string
#  postal_code     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  clinic_id       :bigint
#  medical_record  :text
#
class Patient < ApplicationRecord
  belongs_to :clinic
  has_many :contacts, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :internments, dependent: :destroy

  validates :firstname, :lastname, presence: true
  validates :document_number, presence: true, uniqueness: true

  scope :by_clinic, -> (clinic_id) {
    where(clinic_id: clinic_id)
  }

  def full_name
  	[firstname, lastname].join(' ')
  end
end
