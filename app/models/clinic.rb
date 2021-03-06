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
  validates :beds_voluntary, :beds_judicial, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :beds_qty, on: :update

  scope :by_clinic, lambda { |clinic_id|
    where(id: clinic_id)
  }

  def clinic_id
    id
  end

  def total_beds(bed_type)
    beds_judicial if bed_type == 'judicial'
    beds_voluntary if bed_type == 'voluntario'
  end

  def beds_qty
    voluntary = beds_voluntary >= internments.open_voluntary.count
    judicial = beds_judicial >= internments.open_judicial.count
    return true if voluntary && judicial

    errors.add(:base, 'No puede haber menos camas que internaciones activas')
  end
end
