class Room < ApplicationRecord
  belongs_to :user, optional: true
  has_many :brochures

end
