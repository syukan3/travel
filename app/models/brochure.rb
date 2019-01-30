class Brochure < ApplicationRecord
  require 'date'

  has_many :members
  has_many :users, through: :members

  has_many :days
end
