class Spot < ApplicationRecord
  belongs_to :day, optional: true
  acts_as_list scope: :day

  validates :location_name, presence: true
  validates :lat, presence: true
  validates :lng, presence: true

end
