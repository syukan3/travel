class Day < ApplicationRecord
  belongs_to :brochure, optional: true
  has_many :spots, -> { order(position: :asc) }

  acts_as_list scope: :brochure


end
