class Member < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :brochure, optional: true

  # has_many :users
	# has_many :brochures

end
