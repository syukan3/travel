class Brochure < ApplicationRecord
  belongs_to :room, optional: true
  has_many :members
  has_many :routes

  # belongs_to :member, optional: true

end
