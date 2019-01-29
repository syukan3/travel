class Day < ApplicationRecord
  belongs_to :brochure, optional: true
  has_many :spots

end
