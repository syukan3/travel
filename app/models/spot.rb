class Spot < ApplicationRecord
  belongs_to :day, optional: true

end
