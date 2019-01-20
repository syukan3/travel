class Room < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :member, optional: true
  has_many :brochures

end
