class Brochure < ApplicationRecord
  belongs_to :room, optional: true
end
