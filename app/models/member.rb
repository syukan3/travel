class Member < ApplicationRecord
  belongs_to :user, optional: true

end
