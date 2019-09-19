# == Schema Information
#
# Table name: report_definitions
#
#  id          :bigint           not null, primary key
#  name        :string
#  type        :string
#  periodicity :date
#  text        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ReportDefinition < ApplicationRecord
  self.inheritance_column = :_type_disabled
  validates :name, :type, :periodicity, presence: true
end
