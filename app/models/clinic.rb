# frozen_string_literal: true

# == Schema Information
#
# Table name: clinics
#
#  id             :bigint           not null, primary key
#  name           :string
#  cuit           :string
#  habilitation   :string
#  beds_voluntary :integer
#  beds_judicial  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Clinic Model
class Clinic < ApplicationRecord
  has_many :patients
  has_many :internments, through: :patients
  has_many :users, dependent: :nullify

  validates :name, :habilitation, :cuit, presence: true

  scope :by_clinic, -> (clinic_id) {
    where(id: clinic_id)
  }

  def clinic_id
    self.id
  end

  def total_beds
    self.beds_voluntary.to_i + self.beds_judicial.to_i
  end
end
