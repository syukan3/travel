require 'date'
class Brochure < ApplicationRecord
  has_many :members
  has_many :users, through: :members
  has_many :days, -> { order(position: :asc) }
  has_one_attached :avatar
  
  validates :title, presence: true
  validates :duration, presence: true
  validates :start_date, presence: true
end
